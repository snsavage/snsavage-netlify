---
title: Passing Ruby Objects as Method Arguments
date: 2017-02-12 15:15 UTC
author: Scott Savage
tags: flatiron school, ruby
published: true
---

One part of the Ruby language has tripped me up on several occasions.  In Ruby, passing an object (i.e. just about everything in Ruby) as an argument to a method gives you a reference to that object.  Therefore changes to the object inside of the method are reflected on the original object.

READMORE

```ruby
	def return_the_object_id(object)
		object.object_id
	end
```

The best place to start is with a simple example.  Ruby objects are assigned unique object ids.  The method above simply returns the object id of the passed in object.

```
	2.3.1 :007 > string = "Hello World!"
	 => "Hello World!"
	2.3.1 :008 > string.object_id
	 => 70334666559080
	2.3.1 :009 > return_the_object_id(string)
	 => 70334666559080
```

If we define an object, in this case a string, we can see the object id assigned to that string by calling ```#object_id``` on that string.  Passing the string to ```#return_the_object_id``` returns a matching object id, demonstrating that the object inside of the method matches the string defined outside of the method.

```ruby
	def modify_array(arr)
		array << c"
	end
```

So then, what happens if we modify an object inside of a method?  The above method takes an array as an argument and then adds an element onto the array. 

```
	2.3.1 :002 > test_array = ["a", "b"]
	 => ["a", "b"]
	2.3.1 :003 > test_array.object_id
	 => 70334666661200
	2.3.1 :004 > modify_array(test_array)
	 => ["a", "b", "c"]
	2.3.1 :005 > test_array
	 => ["a", "b", "c"]
	2.3.1 :006 > test_array.object_id
	 => 70334666661200
 ```
 
Using ```#modify_array``` shows that the original array will be modified inside of the method.  The object ids show no change indicating that the original object has been modified.

This same scenario, with both Ruby arrays and hashes is where I've found trouble.  I don't expect these side effects to happen.  It's important to remember that methods that modify an object will also modify that original object.  Since Ruby arrays and hashes are both objects they will have these side effects too.

```ruby
	def assign_array(array)
		new_array = array
		new_array.object_id
	end
```

```
	2.3.1 :005 > test_array = ["a", "b"]
	 => ["a", "b"]
	2.3.1 :006 > test_array.object_id
	 => 70257692546900
	2.3.1 :007 > assign_array(test_array)
	 => 70257692546900
```

Let's go a little deeper.  In the above method, I initially expect ```#assign_array``` to return a new object id.  But ```new_array``` still references the original array.  So assigning an object to a new variable does not create a new copy of that object, just another reference.  

Preventing this can be solved with a few different methods: ```#dup```, ```#clone```, and ```#freeze```.

```
	def dup_assign_array(array)
		new_array = array.dup
		new_array.object_id
	end
```

```
	2.3.1 :002 > test_array = ["a", "b"]
	 => ["a", "b"]
	2.3.1 :003 > test_array.object_id
	 => 70158454806140
	2.3.1 :004 > dup_assign_array(test_array)
	 => 70158454752000
	2.3.1 :005 > return_array = modify_array(test_array.dup)
	 => ["a", "b", "c"]
	2.3.1 :006 > test_array
	 => ["a", "b"]
	2.3.1 :007 > return_array.object_id
	 => 70158454702900
```

In ```#dup_assign_array```, when assigning the array to new_array, I've used the ```#dup```[^1] method.  You can see that the object ids change when using ```#dup```.  

If I then pass the original ```test_array``` into ```#modify_array``` and call ```#dup```, ```test_array``` will not be modified, but a new ```return_array``` will be created with the modification and a new object id.  

```ruby
	2.3.1 :008 > test_array[0].replace("z")
	 => "z"
	2.3.1 :009 > test_array
	 => ["z", "b"]
	2.3.1 :010 > return_array
	 => ["z", "b", "c"]
 ```

It's important to note that ```#dup``` will create a duplicate copy of an object, but not any objects referenced by that object.  In the above example, even though ```test_array``` and ```return_array``` have two different object ids, modifying one of the strings in the array will modify that string in the other.  In this case the string "a" was changed to "z" and this change was reflected in both arrays. 

```#clone``` is similar to ```#dup``` with some important distinctions.  First, with ```#dup```, "any modules that the object has been extended with will not be copied"[^2].  So, ```#dup``` will not create an exact copy.  

```
	2.3.1 :011 > test_array = ["a", "b"]
	 => ["a", "b"]
	2.3.1 :012 > test_array.freeze
	 => ["a", "b"]
	2.3.1 :013 > modify_array(test_array)
	RuntimeError: can't modify frozen Array
	2.3.1 :014 > test_array[0].replace("z")
	 => "z"
	2.3.1 :015 > test_array
	 => ["z", "b"]
```

The second difference deals with ```#freeze```.  ```#freeze``` will permanently prevent an object from being modified.  Trying to modify a frozen object raises a ```RuntimeError```.  However, the objects references by the frozen object can still be modified.  When a frozen object is cloned, the cloned object will still be frozen.  A duplicated object will not be frozen [^3].

*As a side note, the Ruby documentation for ```#freeze``` indicates that "[o]bjects of the following classes are always frozen: Integer, Float, Symbol."[^2].  I think that this caused some of my initial confusion.*

I hope this helps to clear up any confusion regarding how Ruby handles objects passed as arguments to methods.  Just remember, Ruby is passing objects by reference, so changes to an object in one place will also be seen in other places that reference the object.

Please direct comments and questions [here](https://www.snsavage.com/contact.html). 


[^1]: [https://ruby-doc.org/core-2.4.0/Object.html#method-i-dup](https://ruby-doc.org/core-2.4.0/Object.html#method-i-dup)
[^2]: [https://ruby-doc.org/core-2.4.0/Object.html#method-i-freeze](https://ruby-doc.org/core-2.4.0/Object.html#method-i-freeze)
[^3]: [The Well-Grounded Rubyist, Second Edition, By: David A. Black, Page: 59](https://www.manning.com/books/the-well-grounded-rubyist-second-edition)
  



 
 
