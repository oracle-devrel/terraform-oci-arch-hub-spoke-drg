## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_vcn" "dmz" {
  cidr_block     = var.dmz_vcn_cidr_block
  dns_label      = var.dmz_vcn_dns_label
  compartment_id = var.compartment_ocid
  display_name   = var.dmz_vcn_display_name
  defined_tags   = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

#IGW
resource "oci_core_internet_gateway" "dmz_internet_gateway" {
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.dmz.id
    enabled = "true"
    display_name = "IGW_dmz"
    defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

#Default route table dmz
resource "oci_core_default_route_table" "dmz_default_route_table" {
    manage_default_resource_id = oci_core_vcn.dmz.default_route_table_id
    route_rules {
        network_entity_id = oci_core_internet_gateway.dmz_internet_gateway.id
        destination       = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
    }
    route_rules {
        network_entity_id = oci_core_drg.drg01.id
        destination       = var.spoke01_vcn_cidr_block
        destination_type  = "CIDR_BLOCK"
    }
    route_rules {
        network_entity_id = oci_core_drg.drg01.id
        destination       = var.spoke02_vcn_cidr_block
        destination_type  = "CIDR_BLOCK"
    }
    defined_tags         = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}



#dmz pub subnet
resource "oci_core_subnet" "dmz_subnet_pub01" {
    cidr_block = var.dmz_subnet_pub01_cidr_block
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.dmz.id
    display_name = var.dmz_subnet_pub01_display_name
    defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

