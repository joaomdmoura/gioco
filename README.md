![Alt text](http://joaomdmoura.github.com/gioco/assets/images/new_logo.png "A gamification gem for Ruby on Rails applications")

# Gioco (current version - 0.3.6)
A **gamification** gem to Ruby on Rails applications

![Alt text](https://secure.travis-ci.org/joaomdmoura/gioco.png?branch=master "Travis CI")
![Dependency Status](https://gemnasium.com/joaomdmoura/gioco.png)

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
Gioco have two optionals setup parameters, ``` --points ``` and ``` --types ```, it can be used togheter or not.

Example.

```
rails g gioco:setup MODEL_NAME --points --types;
```

or

```
rails g gioco:setup MODEL_NAME;
```

The optional ``` --points ``` argument will setup the gioco with a points system.
And the optional argument ``` --types ```, provide an environment of multiple types of badges and points ( If the oprtion ``` --points ``` is being used too ). 
You can read more about how the badge, level and points implementation work at the [Documentation](http://joaomdmoura.github.com/gioco/)


Usage
------------

###Badge
After setup gioco with you application you are able to add or remove Badges as you want using the following commands:
PS. The boolean DEFAULT option is responsible to add a specific badge to all your **current** resources registrations.

####Add

To add Badges you will use rake tasks, the arguments will changing according the setup arguments that you used:

Examples.

With ```--points``` option:
```
	rake gioco:add_badge[BADGE_NAME, POINTS, DEFAULT]
```

With ```--types``` option:
```
	rake gioco:add_badge[BADGE_NAME, TYPE, DEFAULT]
```

With ```--points``` and ```--types``` option:
```
	rake gioco:add_badge[BADGE_NAME, POINTS, TYPE, DEFAULT]
```

Without ```--points``` and ```--types``` option:

```
	rake gioco:add_badge[BADGE_NAME, DEFAULT]
```

####Remove

And to remove Badges use:

Example.

```
	rake gioco:remove_badge[BADGE_NAME]
```

###Methods

After adding the badges as you wish, you will gonna have to start to use it inside your application, and to do this, Gioco will provide some methods that will allow you to easily apply any logic that you might to have without being concerned about small details.

Those methods are:

Resource is the focus of your gamification logic and it should be defined in you setup process.
This method only is usefull when you setup the Gioco with the points system.
**Ps. Type_id should be used only when you already used it as a setup argument**

```
Gioco::Resources.change_points( Resource_id, Points, Type_id )
```

The Badge.add method is responsable to add a specific badge to some resource.

```
Gioco::Badge.add( Resource_id, Badge_id )
```

The Badge.remove method is used to remove a badge of a resource.

```
Gioco::Badge.remove( Resource_id, Badge_id )
```

###Ranking

Gioco provide a method to list all Resources in a ranking inside of an array, the result format will change according the setup arguments you used ( ```--points``` or/and ```--types``` ):

```
Gioco::Ranking.generate
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
> rails g gioco:setup user --points --types;
```

Adding badges to the system using rake tasks, you badges have a pontuation and a type in this case cause I setup gioco using ```--points``` and ```--types``` arguments.

```
# Adding badges of a teacher type
> rake gioco:add_badge[noob,0,teacher,true]
> rake gioco:add_badge[medium,100,teacher]
> rake gioco:add_badge[hard,200,teacher]
> rake gioco:add_badge[pro,500,teacher]

# Adding badges of a commenter type
> rake gioco:add_badge[mude,0,commenter,true]
> rake gioco:add_badge[speaker,100,commenter]
```

Now the gioco is already installed and synced with the applciation and six badges are created.

The both defaults badge ( noob ) already was added to all users that we already have in our database.

Inside you application if we wanna give 100 points to some user, inside your function you have to use the follow method already showed:

```
type =  Type.where( :name => "teacher" )

Gioco::Resources.change_points( user.id, 100, type.id )
```

Or if you wanna add or remove some badge ( consequently the gioco will add or remove the necessary points ):

```
badge = Badge.where( :name => speaker )

Gioco::Badge.add( user.id , badge.id )

Gioco::Badge.remove( user.id , badge.id )
```

To get a ranking of all resources all you need is call:

```
Gioco:Ranking:generate
```

License
------------
Gioco is released under the MIT license:
www.opensource.org/licenses/MIT

This is it!
------------
Well, this is **Gioco** I really hope you enjoy and use it a lot, I'm still working on it so dont be shy, let me know
if something get wrong opening a issue, then I can fix it and we help each other ;)