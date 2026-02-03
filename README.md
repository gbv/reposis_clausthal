# reposis_clausthal

## Installation instructions

* run `mvn clean install`
* copy jar to `~/.mycore/(dev-)mir/lib/`
* configure `~/.mycore/(dev-)mir/.mycore.properties` if necessary

## Development

You can add these to your `~/.mycore/(dev-)mir/.mycore.properties`:
```
MCR.Developer.Resource.Override=/path/to/reposis_hawk/src/main/resources
MCR.LayoutService.LastModifiedCheckPeriod=0
MCR.UseXSLTemplateCache=false
MCR.SASS.DeveloperMode=true
```
