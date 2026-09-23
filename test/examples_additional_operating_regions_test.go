package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

// TestExamplesAdditionalOperatingRegions verifies that Regions listed in
// `additional_operating_regions` are registered on the IPAM even though no pool
// uses them, and that the configuration is idempotent.
//
// Unlike the other example tests this one needs no TEST_ACCOUNT: the example does
// no RAM sharing, so there is no cross-account principal to supply.
func TestExamplesAdditionalOperatingRegions(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/additional_operating_regions",
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	terraform.ApplyAndIdempotent(t, terraformOptions)

	operatingRegions := terraform.OutputList(t, terraformOptions, "operating_regions")

	for _, want := range []string{"eu-west-1", "ap-southeast-2"} {
		if !contains(operatingRegions, want) {
			t.Fatalf("expected operating_regions to contain %q (registered via additional_operating_regions), got %v", want, operatingRegions)
		}
	}
}

func contains(haystack []string, needle string) bool {
	for _, v := range haystack {
		if v == needle {
			return true
		}
	}
	return false
}
