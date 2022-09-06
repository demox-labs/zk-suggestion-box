# private_comment.aleo

## Build Guide

To compile this Aleo program, run:
```bash
aleo build
```

## Usage Guide

### Initialize a permissioned suggestion box

`aleo run initialize_permissioned_box aleo16qlhlqy6xv2m2r6cuvl5grrw0mvruc6kcufmgasn7e7csxfj4y9s8dz3pu`

`>>>`

```
{
  owner: aleo16qlhlqy6xv2m2r6cuvl5grrw0mvruc6kcufmgasn7e7csxfj4y9s8dz3pu.private,
  gates: 0u64.private,
  receiver: aleo1j5v4xl544c24pk485cn9p3jsv078ulywp6j4w5wellrnwlr5rsqsnxfc7w.private,
  timestamp: 0u64.private,
  is_finalized: false.private,
  is_permissioned: true.private,
  message: "".private,
  _nonce: 5938296999667183760959580846649561218839701724375781902382662352193343968408group.public
}
```

### Publish a permissioned suggestion

Make sure to update the `package.json` to the owner of the record first.

```
aleo run permissioned_publish '{
  owner: aleo16qlhlqy6xv2m2r6cuvl5grrw0mvruc6kcufmgasn7e7csxfj4y9s8dz3pu.private,
  gates: 0u64.private,
  receiver: aleo1j5v4xl544c24pk485cn9p3jsv078ulywp6j4w5wellrnwlr5rsqsnxfc7w.private,
  timestamp: 0u64.private,
  is_finalized: false.private,
  is_permissioned: true.private,
  message: "".private,
  _nonce: 5938296999667183760959580846649561218839701724375781902382662352193343968408group.public
}' 13u64 \"some\ private\ message\"
```

`>>>`

```

```
