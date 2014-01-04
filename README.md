![Alt text](http://joaomdmoura.github.io/gioco/assets/images/logo.png "A gamification gem for Ruby on Rails applications")

# Gioco (current version - 1.1.1)
A **gamification** gem to Ruby on Rails applications that use Active Record.

[![Build
Status](https://travis-ci.org/joaomdmoura/gioco.png?branch=master)](https://travis-ci.org/joaomdmoura/gioco)
[![Dependency
Status](https://gemnasium.com/joaomdmoura/gioco.png)](https://gemnasium.com/joaomdmoura/gioco)
[![Coverage Status](https://coveralls.io/repos/joaomdmoura/gioco/badge.png?branch=master)](https://coveralls.io/r/joaomdmoura/gioco)
[![Code
Climate](https://codeclimate.com/github/joaomdmoura/gioco.png)](https://codeclimate.com/github/joaomdmoura/gioco)

## Description

**Gioco** is an easy-to-implement gamification gem based on plug and play concepts.
With **Gioco** you are able to implement gamification logic such as badges, levels and points / currencies.
Whether you have an existing database or starting from scratch, **Gioco** will smoothly integrate everything and provide
all methods that you might need.

## ScreenCast

**Warning:** _it have some deprecated details._

A **Gioco** overview screencast is available at [Youtube](http://www.youtube.com/watch?v=Pt2sAA8JuEg).

## Installation

**Gioco** is available through [Rubygems](http://rubygems.org/gems/gioco) and can be installed by:

adding it in Gemfile:

```ruby
gem 'gioco'
```

and running the bundler:

    $ bundle install

## Setup

**To setup Gioco with your application:**

    rails g gioco:setup

Next, you will be prompted to provide your **Resource Model**. This is generally the **User** model.

### Parameters:

**Gioco** has two optional setup parameters, `--points` and `--kinds`. These can be used together, or separately:

    rails g gioco:setup --points --kinds

`--points` argument will setup **Gioco** with a points system;

`--kinds` will setup an environment with multiple kinds of badges.

If `--kinds` is used with `--points` then `kinds` will be able to represent kinds of points as well.

You can read more about how the badge, level and points implementations work at the [Documentation](http://joaomdmoura.github.com/gioco/).

## Usage

### Badge

After you've setup **Gioco** in your application, you'll be able to add and remove **Badges** using the following commands:

**Note:** The DEFAULT (boolean) option is responsible for adding a specific badge to all **current** resource registrations.

#### Creating Badges

To add Badges you will use rake tasks.
Note: The arguments will change depending on which setup options you chose.

Examples:

For setups with `--points`:

    rake gioco:add_badge[BADGE_NAME,POINTS_NUMBER,DEFAULT]

For setups with `--kinds`:

    rake gioco:add_badge[BADGE_NAME,KIND_NAME,DEFAULT]

For setups with `--points` and `--kinds`:

    rake gioco:add_badge[BADGE_NAME,POINTS_NUMBER,KIND_NAME,DEFAULT]

For setups without `--points` or `--kinds`:

    rake gioco:add_badge[BADGE_NAME,DEFAULT]

#### Destroying Badges

Example:

With `--kinds` option:

    rake gioco:remove_badge[BADGE_NAME,KIND_NAME]

Without `--kinds` option:

    rake gioco:remove_badge[BADGE_NAME]

#### Destroying Kinds

Example:

    rake gioco:remove_kind[KIND_NAME]

**Note:** Before destroying a kind, you must destroy all badges that relate to it.

## Methods

#### Let's assume that you have setup Gioco defining your **User** model as the **Resource**

After adding the badges as you wish, you will have to start to use it inside your application,
and to do this, **Gioco** will provide and attach some methods that will allow you to easily apply
any logic that you might have, without being concerned about small details.

### Resource Methods

Resource is the focus of your gamification logic and it should be defined in your setup process.

#### Change Points

Updating, adding or subtracting some amount of points of a resource. It will also remove or add the badges that was affected by the ponctuation change. **It will return a hash with the info related of the badges added or removed.** This method only is usefull when you setup the **Gioco** with the points system.

**Note:** `kind_id` should be used only when you already used it as a setup argument.

```ruby
user = User.find(1)
user.change_points({ points: points, kind: kind_id }) # Adds or Subtracts some amount of points of a kind
```

If you have setup **Gioco** without `--kinds` then you should only pass the points argument instead of a hash:

```ruby
user = User.find(1)
user.change_points(points) # Adds or Subtracts some amount of points
```

#### Next Badge?

Return the next badge information, including percent and points info.

**Note:** `kind_id` should be used only when you already used it as a setup argument.

```ruby
user = User.find(1)
user.next_badge?(kind_id) # Returns the information related to the next badge the user should earn
```

#### Get Badges

In order to get the badges or levels of you resource, all you have to do is:

```ruby
user = User.find(1)
user.badges # Returns all user badges
```

### Badges Methods

#### Add

Add a Badge to a specific resource, **it will return the badge added, or if you are using points system it will return a hash with all badges that had been added**:

```ruby
badge = Badge.find(1)
badge.add(resource_id) # Adds a badge to a user
```

#### Remove

Remove a Badge of a specific resource, **it will return the badge removed, or if you are using points system it will return a hash with all badges that had been removed**:

```ruby
badge = Badge.find(1)
badge.remove(resource_id) # Removes a badge from a user
```

### Ranking Methods

#### Generate

**Gioco** provides a method to list all Resources in a ranking inside of an array, the result format will change according the setup arguments you used (`--points` or/and `--kinds`):

```ruby
Gioco::Ranking.generate # Returns a object with the ranking of users
```

## Example

All basic usage flow to add **Gioco** in an application:

#### Let's assume that you have setup Gioco defining your _User_ model as the _Resource_:

```
$ rails g gioco:setup --points --kinds;
...
What is your resource model? (eg. user)
> user
```

Adding badges to the system using rake tasks, your badges have a pontuation and a kind in this case cause I setup **Gioco** using `--points` and `--kinds` arguments.

    # Adding badges of a teacher kind
    $ rake gioco:add_badge[noob,0,teacher,true]
    $ rake gioco:add_badge[medium,100,teacher]
    $ rake gioco:add_badge[hard,200,teacher]
    $ rake gioco:add_badge[pro,500,teacher]

    # Adding badges of a commenter kind
    $ rake gioco:add_badge[mude,0,commenter,true]
    $ rake gioco:add_badge[speaker,100,commenter]

Now **Gioco** is already installed and synced with the applciation and six badges are created.

The both defaults badge (noob) already was added to all users that we already have in our database.

Inside your application if you want to give 100 points to some user, inside your function you have to use the following method:

```ruby
kind =  Kind.where(:name => "teacher")
user = User.find(1)

user.change_points({ points: 100, kind: kind.id })
```

Or if you wanna add or remove some badge **(consequently Gioco will add or remove the necessary points)**:

```ruby
badge = Badge.where(:name => speaker)
user  = User.find(1)

badge.add(user.id)
badge.remove(user.id)
```

Get the information related to the next badge that the user want to earn:

```ruby
kind =  Kind.where(:name => "teacher")
user = User.find(1)

user.next_badge?(kind.id)
```

In order to get a ranking of all resources, all you need is call:

```ruby
Gioco::Ranking.generate
```

## Deploy

Once that you decide that you are ready to deploy / update your application, if you added or removed any **kind** or
**badge**, you need to run the ```sync_database``` rake task, that will do the job of recreate your actions in production,
or any environments.

```
$ rake gioco:sync_database
```

## License

**Gioco** is released under the [MIT license](www.opensource.org/licenses/MIT).

## This is it!

Well, this is **Gioco** I really hope you enjoy and use it a lot, I'm still working on it so dont be shy, let me know
if something get wrong opening a issue, then I can fix it and we help each other ;)
