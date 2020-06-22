# PsTodoTxt

This is a PowerShell CLI to the [Todo.txt](http://todotxt.com/) todo file format with some PowerShell like features.

## Goal

The goal of this project is to create a command line interface to todo.txt.

## Todo.txt Components

Each todo is split into parts and is stored as an PSCustomObject as properties with the names as shown below:

* **DoneDate (String) (Optional)**
  * Completion (done) date of the task in the format YYYY-MM-DD.
  * If it exists it will be prefixed with an **x** and must be the first item on the line;
* **CreatedDate (String) (Optional)**
  * Date the todo was created in the format YYYY-MM-DD.
  * If this exists it must appear after the DoneDate and before the Priority.
  * Note that PSTodoTxt **always** adds a created date to tasks if they do not already have one. This includes existing tasks that have been read and written back to the todo.txt file;
* **Priority (String) (Optional)**
  * This is the priority of the todo in the format '(<A-Z>)'.
  * While it is shown to be a String it is in fact a String of a single uppercase letter.
  * If it exists it will appear after CreatedDate. Note that PSTodoTxt will change any new or existing tasks when they are read and rewritten to the todo.txt file.
* **Task (String) (Mandatory)**
  * This is the todo task, or description.
  * It effectively is all of hte text left after you remove all the other parts.
* **Context / List (String[]) (Optional)**
  * One or more contexts, or lists, of the todo.
  * If it exists it will be stored in the object without the leading **@**.
* **Project / Tag (String[]) (Optional)**
  * One or more projects, or tags, of the todo.
  * If it exists it will be stored in the object without the leading **+**.
* **Addon (Hashtable) (Optional)**
  * One or more addons of the todo.
  * If these exist they are stored as a key:value in the hashtable. For example the addon due:2016-02-12 will be stored as the key **due** and the value **2016-02-12**.

More details can be found on the [Todo.txt Format](https://github.com/ginatrapani/todo.txt-cli/wiki/The-Todo.txt-Format) page.

## Configuration format

See module help file.

# TODO

Nothing yet - not released version 1 yet!

# References

* The [Todo.txt Format](https://github.com/ginatrapani/todo.txt-cli/wiki/The-Todo.txt-Format)
* [SimpleTask](https://github.com/mpcjanssen/simpletask-android/blob/master/app/src/main/assets/listsandtags.en.md) - took the idea for some of the addons from here (recurring tasks, hidden tasks etc.)
* [How to GTD with SimpleTask](https://gist.github.com/alehandrof/9941620)
* [How TaskWarrior handles Urgency](http://taskwarrior.org/docs/urgency.html)
* [How topydo handles urgency](https://github.com/bram85/topydo/wiki/Importance)

# Contributing

* Source hosted at [GitHub](https://github.com/pauby/pstodotxt)
* Report issues/questions/feature requests on [GitHub Issues](https://github.com/pauby/pstodotxt/issues)

Pull requests are very welcome! Make sure your patches are well tested. Ideally create a topic branch for every separate change you make. For example:

* Fork the repo
* Create your feature branch (git checkout -b my-new-feature)
* Commit your changes (git commit -am 'Added some feature')
* Push to the branch (git push origin my-new-feature)
* Create new Pull Request
