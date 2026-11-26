# reposis_clausthal

[MIR](https://github.com/MyCoRe-Org/mir) plugin with project-specific customizations
for the repository of TU Clausthal.

Compatible with **MIR 2025.06.x**.

## Installation

* Run `mvn clean install`.
* Copy the generated JAR to `~/.mycore/(dev-)mir/lib/`.
* Configure `mycore.properties` if necessary.

## Development

To enable hot reloading of XSL and frontend resources during development,
add the following properties to `mycore.properties`:

```properties
MCR.Developer.Resource.Override=/path/to/reposis_ostasien/src/main/resources
MCR.LayoutService.LastModifiedCheckPeriod=0
MCR.UseXSLTemplateCache=false
MCR.SASS.DeveloperMode=true
```
