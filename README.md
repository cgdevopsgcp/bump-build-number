# Codefresh Bump Build Number

This step will help you maintain a build number annotation at the pipeline level. The build number will be updated every time that the step is executed using the codefresh CLI.

## Prerequisites

- If you want to seed the build number at something other than 1, create a number annotation at the pipeline level with the name build_number and set it appropriately

### Step arguments

Name|Required|Description
---|---|---
CF_BUILD_ID | Yes | Set this to ${{CF_BUILD_ID}}

### Codefresh.yml

```yaml
version: '1.0'
steps:
  BumpVersionNumber:
    title: Bump Version Number
    type: bump
    arguments:
      CF_BUILD_ID: ${{CF_BUILD_ID}}
```