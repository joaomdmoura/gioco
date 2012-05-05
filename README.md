![Alt text](http://joaomdmoura.github.com/gioco/assets/images/new_logo.png "A gamification gem for Ruby on Rails applications")
# Gioco (current version - 0.1.8)
A **gamification** gem to Ruby on Rails applications

![Alt text](https://secure.travis-ci.org/joaomdmoura/gioco.png?branch=master "Travis CI")

Description
------------
Gioco is a easy-to-implement gamification gem based on plug and play concept.
With Gioco you are able to implement any logic you could have with a badge, level and points implementation.
Dosen't matter if you already have a full and functional database, Gioco will smoothly integrate everything and provide all methods that you might need.
For more information just keep reading.


Installation
------------
Gioco is available through [Rubygems](http://rubygems.org/gems/gioco) and can be installed via:
```
$ gem install gioco
```
Or adding it in Gemfile
```
gem 'gioco'
```
and running the bundler
```
$ bundle install
```


Setup
------------
**To setup gioco with you application**

The MODEL_NAME should be replaced for the model you want to be, as gioco treat, the resource of the gamification. (eg. user )

```
rails g gioco:setup MODEL_NAME --points;
```

or

```
rails g gioco:setup MODEL_NAME;
```

The optional ``` --points ``` argument will setup the gioco with a points system. You can read more about how the badge, level and points implementation work at the [Documentation](http://joaomdmoura.github.com/gioco/)


Usage
------------

###Badge
After setup gioco with you application you are able to add or remove Badges as you want using the following commands:

To add Badges use:

```
	rake gioco:add_badge[BADGE_NAME,POINTS,DEFAULT]
```

Or if you installed gioco without points option:

```
	rake gioco:add_badge[BADGE_NAME,DEFAULT]
```

And to remove Badges use:

```
	rake gioco:remove_badge[BADGE_NAME]
```

The boolean DEFAULT option is responsible to add a specific badge to all your current resources registrations.

###Methods

After adding the badges as you wish, you will gonna have to start to use it inside your application, and to do this, Gioco will provide some methods that will allow you to easily apply any logic that you might to have without being concerned about small details.

Those methods are:

Resource is the focus of your gamification logic and it should be defined in you setup process.
This method only is usefull when you setup the Gioco with the points system.
The ``` Resource_obj ``` is an optional argument that can be use to avoid useless queries on database, so instead of pass a Resource_id you can pass it as ``` nil ``` and the resource obeject at the last parameter.

```
Gioco::Resources.change_points( Resource_id, Points, Resource_obj[optional] )
```

The Badge.add method is responsable to add a specific badge to some resource, again, the ``` Resource_obj ``` and the ``` Badge_obj ``` are optinal arguments that can be passed to avoid another query to get them if you already have it.

```
Gioco::Badge.add( Resource_id, Badge_id, Resource_obj[optional], Badge_obj[optional] )
```

The Badge.remove method is used to remove a badge of a resource, the ``` Resource_obj ``` and the ``` Badge_obj ``` follow the same logic of the others optional arguments.

```
Gioco::Badge.remove( Resource_id, Badge_id, Resource_obj[optional], Badge_obj[optional] )
```

###Ranking

Gioco provide a method to list all Resources in a ranking inside of an array:

```
Gioco::Core.ranking
```

###Get Badged and Levels

To get the badges or levels of you resource all you have to do is: (replace RESOURCE_NAME for your resource model name)

```
RESOURCE_NAME.badges
RESOURCE_NAME.levels
```


Example
------------
All basic usage flow to add gioco in an application using User as resource:

```
> rails g gioco:setup user --points;
...

> rake gioco:add_badge[noob,0,true]
> rake gioco:add_badge[medium,100]
> rake gioco:add_badge[hard,200]
> rake gioco:add_badge[pro,500]
```

Now the gioco is already installed and synced with the applciation and four badges are created.

The default badge ( noob ) already was added to all users that arelady have some register in database.

Inside you application if we wanna give 100 points to users that get to this method, all we have to do is use the follow method already showed:

```
Gioco::Resources.change_points( current_user.id, 100 )
```

Or if you wanna add or remove some badge, consequently adding or removing the necessary points:

```
Gioco::Badge.add( current_user.id , 2 )

Gioco::Badge.remove( current_user.id , 2 )
```

To get a ranking of all resources all you need is call:

```
Gioco:Core:ranking
```

License
------------
Gioco is released under the MIT license:
www.opensource.org/licenses/MIT

This is it!
------------
Well, this is **Gioco** I really hope you enjoy and use it a lot, I'm still working on it so dont be shy, let me know
if something get wrong opening a issue, then I can fix it and we help each other ;)