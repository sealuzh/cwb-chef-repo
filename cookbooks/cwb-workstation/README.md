# cwb-workstation

Sets up a demo chef workstation with all Chef utils configured.
Configures the browser-based IDE [theia](https://github.com/theia-ide/theia) with the [theia-ruby-extension](https://github.com/theia-ide/theia-ruby-extension)

## Attributes

Notice that `server_host`, `client_key`, and `validation_key` are REQUIRED.
It is highly recommened to pin the `chef_dk` version.

Check [attributes/default.rb](./attributes/default.rb) for more details.

## Theia Requirements

* Source [Build your own IDE](https://www.theia-ide.org/doc/Composing_Applications.html)
* Node v8
* Yarn

* Ruby 2.4.4 (for solargraph)
* solargraph gem
