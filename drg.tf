## Copyright (c) 2022, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_drg" "drg01" {
    compartment_id = var.compartment_ocid
    display_name = var.drg01_display_name
    defined_tags = {"${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_drg_attachment" "drg01_dmz_attachment" {
    drg_id = oci_core_drg.drg01.id
    vcn_id = oci_core_vcn.dmz.id
    display_name = var.drg01_dmz_attachment_display_name
}

resource "oci_core_drg_attachment" "drg_spoke01_attachment" {
    drg_id = oci_core_drg.drg01.id
    vcn_id = oci_core_vcn.spoke01.id
    display_name = var.drg01_spoke01_attachment_display_name
}

resource "oci_core_drg_attachment" "drg_spoke02_attachment" {
    drg_id = oci_core_drg.drg01.id
    vcn_id = oci_core_vcn.spoke02.id
    display_name = var.drg01_spoke02_attachment_display_name
}
