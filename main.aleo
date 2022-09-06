/** The 'suggestion_box.aleo' program.
* This program enables someone to create a permissionless or permissioned suggestion box.
* A suggestion is a message that only the owner of the suggestion box can read.
* 
* A permissionless suggestion box enables anyone to submit a suggestion up to a total amount of suggestions specified on intialization.
* A permissioned suggestion box enables a specific user to submit a suggestion privately if they've been allowed to by the box owner.
**/
program suggestion_box.aleo;

// A message containing 256 ascii characters
record suggestion:
    owner as address.private;
    gates as u64.private;
    receiver as address.private; // address of receiver
    timestamp as u64.private;
    is_finalized as boolean.private;
    is_permissioned as boolean.private;
    message as string.private;

mapping permissionless_suggestions:
    // The receiver hashed into a field
    key data as field.public;
    // The number of suggestions that a "sender" can post
    value amount as u32.public;

interface sender_receiver:
    sender as address;
    receiver as address;

mapping permissioned_suggestions:
    key data as field.public;
    value amount as u8.public;

// The owner of a suggestion box initializes the box with a total number of suggestions they're willing to receive.
function initialize_permissionless_box:
    input r0 as u32.private;

    hash.bhp256 self.caller into r1;

    finalize r1 r0;

finalize initialize_permissionless_box:
    input r0 as field.public;
    input r1 as u32.public;

    increment permissionless_suggestions[r0] by r1;

// Anyone can privately publish a suggestion which then only the suggestion box owner can read
function permissionless_publish:
    input r0 as address.private; // Receiver
    input r1 as u64.private; // Timestamp
    input r2 as string.private; // Message

    cast r0 0u64 r0 r1 true false r2 into r3 as suggestion.record;

    hash.bhp256 r0 into r4;

    output r3 as suggestion.record;

    finalize r4;

// Decrement the total number of suggestions left to receive
finalize permissionless_publish:
    input r0 as field.public;

    decrement permissionless_suggestions[r0] by 1u32;

// In the permissioned case, a suggestion box owner does:
// 1. Approves a specific address to send suggestions
// 2. Gives the sender a record to use when sending suggestions
// The ability to send suggestions is stored publically so multiple senders can be sure they're not the only sender
function initialize_permissioned_box:
    input r0 as address.private; // sender address

    cast r0 0u64 self.caller 0u64 false true "" into r1 as suggestion.record;
    
    cast r0 self.caller into r2 as sender_receiver;
    hash.bhp256 r2 into r3;

    output r1 as suggestion.record;

    finalize r3;

finalize initialize_permissioned_box:
    input r0 as field.public;

    increment permissioned_suggestions[r0] by 1u8;

// A permissioned address publishes a suggestion, doing:
// 1. Create a record for the suggestion box owner ("receiver") to read
// 2. Create a record for themselves to publish more suggestions later
function permissioned_publish:
    input r0 as suggestion.record; // Record created by receiver
    input r1 as u64.private; // Timestamp
    input r2 as string.private; // Message

    assert.eq self.caller r0.owner;
    assert.eq r0.is_finalized false;
    assert.eq r0.is_permissioned true;
    
    cast self.caller r0.receiver into r3 as sender_receiver;
    hash.bhp256 r3 into r4;

    // TODO: When we can access values of mappings, use to check this assert
    //assert.eq permissioned_suggestions[r4] 1u8; 

    cast r0.receiver 0u64 r0.receiver r1 true true r2 into r5 as suggestion.record;
    cast self.caller 0u64 r0.receiver r1 false true "" into r6 as suggestion.record; // Not sure if necessary to ensure record is destroyed & recreated

    output r5 as suggestion.record;
    output r6 as suggestion.record;