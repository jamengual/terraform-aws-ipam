#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

# This example shows `additional_operating_regions`: registering an IPAM operating
# Region that no pool uses yet.
#
# A pool's `locale` must already be an operating Region of the IPAM, and operating
# Regions are otherwise derived from the locales present in `pool_configurations`.
# That creates a chicken-and-egg problem when you want to stand a Region up ahead
# of the first pool that will live there — you cannot add the pool until the Region
# is registered, and the Region is only registered once a pool references it.
#
# `additional_operating_regions` breaks the cycle: the Regions below are registered
# on the IPAM even though no pool has a matching `locale`. A later change can then
# add pools with `locale = "eu-west-1"` (or `ap-southeast-2`) without having to
# touch the IPAM resource itself.

module "basic" {
  # source  = "aws-ia/ipam/aws"
  source = "../.."

  top_cidr = ["10.0.0.0/8"]
  top_name = "additional operating regions example"

  # Register these Regions now, before any pool uses them.
  additional_operating_regions = ["eu-west-1", "ap-southeast-2"]

  pool_configurations = {
    # A single regionless top-level pool. It intentionally sets no `locale`, so
    # none of the operating Regions above come from a pool — they come only from
    # `additional_operating_regions`.
    parent = {
      description = "top-level pool; child Regions registered ahead of their pools"
      cidr        = ["10.0.0.0/16"]
    }
  }
}
