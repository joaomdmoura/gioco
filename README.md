![Alt text](http://joaomdmoura.github.com/gioco/assets/images/new_logo.png "A gamification gem for Ruby on Rails applications")

# Gioco (current version - 1.0.0)
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
Gioco is available through [Rubygems](http://rubygems.org/gems/gioco) and can be installed by:

adding it in Gemfile
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

Gioco have two optionals setup parameters, ``` --points ``` and ``` --types ```, it can be used togheter or not.
The **Resource Model name** will be asked for the setup generator, it's what you want to be, as gioco treat, the resource of the gamification. (eg. user )

Example.

```
rails g gioco:setup --points --types;
```

or

```
rails g gioco:setup;
```

The optional ``` --points ``` argument will setup the gioco with a points system.
And the optional argument ``` --types ```, provide an environment of multiple types of badges and points ( If the option ``` --points ``` is being used too ).
You can read more about how the badge, level and points implementation work at the [Documentation](http://joaomdmoura.github.com/gioco/)


Usage
------------

###Badge
After setup gioco in you application, you'll be able to add and remove **Badges** as you want, using the following commands:

PS. The boolean DEFAULT option is responsible to add a specific badge to all your **current** resources registrations.

####Creating Badges

To add Badges you will use rake tasks, the arguments will changing **according the setup arguments** that you used:

Examples.

With ```--points``` option:
```
	rake gioco:add_badge[BADGE_NAME,POINTS_NUMBER,DEFAULT]
```

With ```--types``` option:
```
	rake gioco:add_badge[BADGE_NAME,TYPE_NAME,DEFAULT]
```

With ```--points``` and ```--types``` option:
```
	rake gioco:add_badge[BADGE_NAME,POINTS_NUMBER,TYPE_NAME,DEFAULT]
```

Without ```--points``` and ```--types``` option:

```
	rake gioco:add_badge[BADGE_NAME,DEFAULT]
```

####Destroying Badges

And to remove Badges use:

Example.

With ```--types``` option:
```
	rake gioco:remove_badge[BADGE_NAME,TYPE_NAME]
```

Without ```--types``` option:
```
	rake gioco:remove_badge[BADGE_NAME]
```

####Destroying Types

To remove Types use:

Example.

```
  rake gioco:remove_type[TYPE_NAME]
```

It's only possible when there it no badges related with this type, so, before you destroy a type you must detroy all badges that belong to it.


Methods
------------

####Let's assume that you have setup gioco defining your **User** model as the **Resource**

After adding the badges as you wish, you will have to start to use it inside your application, and to do this, Gioco will provide and attach some methods that will allow you to easily apply any logic that you might have, without being concerned about small details.

###Resource Methods

Resource is the focus of your gamification logic and it should be defined in you setup process.

####Change Points

Updating, adding or subtactring some amount of points of a resource. It will also remove or add the badges that was affected by the ponctuation change.
**It will return the a hash with the info related of the badges added or removed.**
This method only is usefull when you setup the Gioco with the points system.

**Ps. Type_id should be used only when you already used it as a setup argument**

```
user = User.find(1)
user.change_points({ points: Points, type_id: Type_id })
```

If you have setup Giogo without ```--type``` then you shoul only pass the points argument instead of a hash:

```
user = User.find(1)
user.change_points(Points)
```

####Next Badge?

Return the next badge information, including percent and points info.
**Ps. Type_id should be used only when you already used it as a setup argument**

```
user = User.find(1)
user.next_badge?(Type_id)
```

####Get Badges

To get the badges or levels of you resource all you have to do is:

```
user = User.find(1)
user.badges
```

###Badges Methods

####Add

Add a Badge to a specific resource, **it will return the badge added, or if you are using points system it will return a hash with all badges that ahd been added**

```
badge = Badge.find(1)
badge.add(Resource_id)
```

####Remove

Remove a Badge of a specific resource, **it will return the badge removed, or if you are using points system it will return a hash with all badges that ahd been removed**

```
badge = Badge.find(1)
badge.remove(Resource_id)
```

###Ranking Methods

####Generate

Gioco provide a method to list all Resources in a ranking inside of an array, the result format will change according the setup arguments you used ( ```--points``` or/and ```--types``` ):

```
Gioco::Ranking.generate
```


Example
------------
All basic usage flow to add gioco in an application:

####Let's assume that you have setup gioco defining your **User** model as the **Resource**

```
> rails g gioco:setup --points --types;
...
What is your resource model? (eg. user)
> user
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

Inside your application if you want to give 100 points to some user, inside your function you have to use the following method:

```
type =  Type.where(:name => "teacher")
user = User.find(1)

user.change_points({ points: 100, type_id: type.id })
```

Or if you wanna add or remove some badge **(consequently the gioco will add or remove the necessary points)**:

```
badge = Badge.where(:name => speaker)
user  = User.find(1)

badge.add(user.id)
badge.remove(user.id)
```

Get the iformation related to the next badge that the user want to earn:

```
type =  Type.where(:name => "teacher")
user = User.find(1)

user.next_badge?(type.id)
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