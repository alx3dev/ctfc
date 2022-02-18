## [1.0.0-dev]

Testing changes before merge.

**About:**

 - Allow multiple sources
 - Class-Template based - easy to add more APIs
 - New sources are automatically required and added to `.gemspec`
 - Each source can be required alone
 - List helper - list available sources (required in gem)
 - Cli helper - print colorized output (required only in executable)
 - Save prices in `.csv` table
 - Extract all data in `.json` file

**Security:**

 - `CTFC::Client` use `eval` - to call source class to extract data. Only source name is dinamic, and we check for persistence of source class before evaluation. There's no place for malicious use.

 - Example of eval use in CTFC - call source class to extract data:

```ruby
eval "CTFC::API::#{source_class} if List.sources.include? source_class"
```
