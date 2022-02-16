## [1.0.0-dev]

Testing changes before merge.

**About:**

 - Allow multiple sources
 - Class-Template based - easy to add more APIs
 - New sources are automatically required and added to `.gemspec`
 - Save prices in `.csv` table
 - Extract all data in `.json` file

**Security:**

 - `CTFC::Client` use `eval` - to call source class to extract data. Only source
string is evaluated, but we check for persistence of source class before it.
