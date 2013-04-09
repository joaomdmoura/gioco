![Alt text](http://joaomdmoura.github.com/gioco/assets/images/new_logo.png "A gamification gem for Ruby on Rails applications")

# Gioco (current version - 1.0.1)
A **gamification** gem to Ruby on Rails applications

[![Build
Status](https://travis-ci.org/joaomdmoura/gioco.png?branch=master)](https://travis-ci.org/joaomdmoura/gioco)
[![Dependency
Status](https://gemnasium.com/joaomdmoura/gioco.png)](https://gemnasium.com/joaomdmoura/gioco)
[![Coverage Status](https://coveralls.io/repos/joaomdmoura/gioco/badge.png?branch=master)](https://coveralls.io/r/joaomdmoura/gioco)
[![Code
Climate](https://codeclimate.com/github/joaomdmoura/gioco.png)](https://codeclimate.com/github/joaomdmoura/gioco)

Description
------------
Gioco is an easy-to-implement gamification gem based on plug and play concepts.
With Gioco you are able to implement gamification logic such as badges, levels and points / currencies.
Whether you have an existing database or starting from scratch, Gioco will smoothly integrate everything and provide 
all methods that you might need.

ScreenCast
------------
A Gioco overview screencast is available at [Youtube](http://www.youtube.com/watch?v=Pt2sAA8JuEg):


Installation
------------
Gioco is available through [Rubygems](http://rubygems.org/gems/gioco) and can be installed by:

adding it in Gemfile
```ruby
gem 'gioco'
```
and running the bundler
```
$ bundle install
```


Setup
------------
**To setup gioco with your application**

Gioco has two optional setup parameters, ``` --points ``` and ``` --types ```.
These can be used together, or separate.

Next, you will be prompted to provide your `Resource Model`.
This is generally the `User` model.

```
rails g gioco:setup --points --types;
```

or

```
rails g gioco:setup;
```

``` --points ``` argument will setup Gioco with a points system.
``` --types ``` will setup an environment with multiple types of badges.
If `--types` is used with `--points` then `types` will be able to represent types of points as well.

You can read more about how the badge, level and points implementations work at the [Documentation](http://joaomdmoura.github.com/gioco/)

Usage
------------

###Badge
After you've setup Gioco in your application, you'll be able to add and remove **Badges** using the following commands:
Note: The DEFAULT (boolean) option is responsible for adding a specific badge to all **current** resource registrations.

####Creating Badges

To add Badges you will use rake tasks.
Note: The arguments will change depending on which setup options you chose.

Examples.

For setups with ```--points```:
```
	rake gioco:add_badge[BADGE_NAME,POINTS_NUMBER,DEFAULT]
```

For setups with ```--types```:
```
	rake gioco:add_badge[BADGE_NAME,TYPE_NAME,DEFAULT]
```

For setups with ```--points``` and ```--types```:
```
	rake gioco:add_badge[BADGE_NAME,POINTS_NUMBER,TYPE_NAME,DEFAULT]
```

For setups without ```--points``` or ```--types```:

```
	rake gioco:add_badge[BADGE_NAME,DEFAULT]
```

####Destroying Badges

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

Example.

```
  rake gioco:remove_type[TYPE_NAME]
```

Note: Before destroying a type, you must destroy all badges that relate to it.


Methods
------------

####Let's assume that you have setup Gioco defining your **User** model as the **Resource**

After adding the badges as you wish, you will have to start to use it inside your application, 
and to do this, 
Gioco will provide and attach some methods that will allow you to easily apply 
any logic that you might have, without being concerned about small details.

###Resource Methods

Resource is the focus of your gamification logic and it should be defined in you setup process.

####Change Points

Updating, adding or subtactring some amount of points of a resource. It will also remove or add the badges that was affected by the ponctuation change.
**It will return the a hash with the info related of the badges added or removed.**
This method only is usefull when you setup the Gioco with the points system.

**Ps. Type_id should be used only when you already used it as a setup argument**

```ruby
user = User.find(1)
user.change_points({ points: Points, type: Type_id }) #Add or Subtract some amount of points of a type
```

If you have setup Giogo without ```--type``` then you shoul only pass the points argument instead of a hash:

```ruby
user = User.find(1)
user.change_points(Points) #Add or Subtract some amount of points
```

####Next Badge?

Return the next badge information, including percent and points info.
**Ps. Type_id should be used only when you already used it as a setup argument**

```ruby
user = User.find(1)
user.next_badge?(Type_id) #Returns the information related to the next badge the user should win
```

####Get Badges

To get the badges or levels of you resource all you have to do is:

```ruby
user = User.find(1)
user.badges #Return all user badges
```

###Badges Methods

####Add

Add a Badge to a specific resource, **it will return the badge added, or if you are using points system it will return a hash with all badges that ahd been added**

```ruby
badge = Badge.find(1)
badge.add(Resource_id) #Add a badge to a user
```

####Remove

Remove a Badge of a specific resource, **it will return the badge removed, or if you are using points system it will return a hash with all badges that ahd been removed**

```ruby
badge = Badge.find(1)
badge.remove(Resource_id) #Remove a badge from a user
```

###Ranking Methods

####Generate

Gioco provide a method to list all Resources in a ranking inside of an array, the result format will change according the setup arguments you used ( ```--points``` or/and ```--types``` ):

```ruby
Gioco::Ranking.generate #Return a object with the ranking of users
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

```ruby
type =  Type.where(:name => "teacher")
user = User.find(1)

user.change_points({ points: 100, type: type.id })
```

Or if you wanna add or remove some badge **(consequently the gioco will add or remove the necessary points)**:

```ruby
badge = Badge.where(:name => speaker)
user  = User.find(1)

badge.add(user.id)
badge.remove(user.id)
```

Get the iformation related to the next badge that the user want to earn:

```ruby
type =  Type.where(:name => "teacher")
user = User.find(1)

user.next_badge?(type.id)
```

To get a ranking of all resources all you need is call:

```ruby
Gioco::Ranking.generate
```

License
------------
Gioco is released under the MIT license:
www.opensource.org/licenses/MIT

This is it!
------------
Well, this is **Gioco** I really hope you enjoy and use it a lot, I'm still working on it so dont be shy, let me know
if something get wrong opening a issue, then I can fix it and we help each other ;)
