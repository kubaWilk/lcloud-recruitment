#!/bin/bash
fileName="output.txt"
metadataURL="http://169.254.169.254/latest/meta-data/"
privIPv4Suffix="/local-ipv4"
pubIPv4Suffix="/public-ipv4"
instanceIDSuffix="/instance-id"
secGroupsSuffix="/security-groups"

function call_metadataAPI() {
	curl -s "$metadataURL""$1"
}

function getInstanceInfo() {
	echo "Instance ID: "$(call_metadataAPI "$instanceIDSuffix")
	echo "Public IP: "$(call_metadataAPI "$pubIPv4Suffix")
	echo "Private IP: "$(call_metadataAPI "$privIPv4Suffix")
	echo "Security Groups: "$(call_metadataAPI "$secGroupsSuffix")
	echo "OS: "$(awk -F= '$1== "NAME" || $1== "VERSION" {gsub(/"/, "", $2); printf "%s ", $2}' /etc/os-release)
	echo "Users(with shell permissions): "$(awk -F: '$7 ~ /\/bin\/.*sh$/ {print $1}' /etc/passwd)
}

getInstanceInfo > "./$fileName"
