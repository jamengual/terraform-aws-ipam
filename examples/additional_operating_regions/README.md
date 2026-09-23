# Additional operating Regions

This example demonstrates `additional_operating_regions` — registering IPAM
operating Regions ahead of the pools that will use them.

## The problem it solves

A pool's `locale` must already be an operating Region of the IPAM. Operating
Regions are otherwise inferred from the `locale` values present in
`pool_configurations`. So there is no way, with pools alone, to register a Region
*before* the first pool that lives in it — you cannot add the pool until the
Region is an operating Region, and the Region only becomes one once a pool
references it.

`additional_operating_regions` registers the Regions directly on the IPAM,
independent of any pool. Here, `eu-west-1` and `ap-southeast-2` are registered
even though the only pool (`parent`) sets no `locale`. A later change can then add
pools with `locale = "eu-west-1"` without modifying the IPAM resource.

## Usage

```hcl
module "basic" {
  source = "aws-ia/ipam/aws"

  top_cidr = ["10.0.0.0/8"]
  top_name = "additional operating regions example"

  additional_operating_regions = ["eu-west-1", "ap-southeast-2"]

  pool_configurations = {
    parent = {
      cidr = ["10.0.0.0/16"]
    }
  }
}
```

The `operating_regions` output lists all operating Regions on the IPAM — the home
Region plus the two registered above.
