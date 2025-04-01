# L# Competition
The competition with L# are all the other existing class frameworks and modules that seek to serve the same purpose, albeit with their own implementations which may or may not have the same performance, semantic, or versatility implications as L#. These competing modules are all considered to be compatible with the Roblox IDE.

## Frameworks

### kikito/middleclass
```embed
title: "GitHub - kikito/middleclass: Object-orientation for Lua"
image: "https://opengraph.githubassets.com/e3e287d781c0898be21b3ea129f7c875d3cb088a08d9f92f337b1ab20c07cb6a/kikito/middleclass"
description: "Object-orientation for Lua. Contribute to kikito/middleclass development by creating an account on GitHub."
url: "https://github.com/kikito/middleclass"
```


### TehnoDragon/Nex
```embed
title: "Nex - one module for creating classes"
image: "https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/optimized/5X/7/4/3/3/743328aa27516419d87aa8b084d8c14a12fe32c7_2_1024x512.png"
description: "Nex It is a one module to create classes and has few useful tools. You may get it on roblox or github. On Github you may find a Wiki to learn more about this module. Here is example code, (it was took from github). local class = require(‘nex’) local Square = class “Square” {} -- class “Square” {} == class(“Square”)({}) function Square:init(width, height) self.width = width self.height = height end function Square:area() return self.width * self.height end local mySquare =…"
url: "https://devforum.roblox.com/t/nex-one-module-for-creating-classes/2626799"
```


### ianfinity/OOPer's Dream
```embed
title: "Object Oriented Programmer’s Dream, a module so you never have to worry about weird work arounds to create classes ever again"
image: "https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/5X/a/c/f/0/acf0fbbd3d747e65cebeed3d0d9dfc2285b3147d.png"
description: "v2.0.1 Release INTRO Have you ever hated that you can’t make classes in roblox? Or rather, that you have to do weird work arounds to get one to work? Well worry no more! Presenting, OOPer’s Dream. A simple module/package that will allow you to create nice and organized classes, with class extending, inheritence, static and nonstatic methods, public and private methods, and properties. There’s even a plugin with a nice gui to manage all your classes and methods! Simply put the folder under re…"
url: "https://devforum.roblox.com/t/object-oriented-programmers-dream-a-module-so-you-never-have-to-worry-about-weird-work-arounds-to-create-classes-ever-again/2230083"
```

### FlowTonio/Class Module
```embed
title: "(OOP) Class Module"
image: "https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/optimized/5X/9/3/f/c/93fc48f5f32af407ee44bd8da01d8b056cd79067_2_1024x535.jpeg"
description: "So I’ve been using OOP on Roblox a bit more lately, and I wanted to get a better understanding of it. And so I thought: What better way to learn about OOP than to (almost) remake it yourself? So I did… It’s very similar to Python’s Class system(with minor alterations since Lua…) Here’s an example of it in action: local Class = require(game:GetService(“ReplicatedStorage”).Class) local Vehicle = Class{ __init__ = function(self, category, speed) self.category = category self.speed = spe…"
url: "https://devforum.roblox.com/t/oop-class-module/180795"
```

### PepeElToro/Class
```embed
title: "Object Oriented Programming (OOP) Advanced Inheritance"
image: "https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/5X/7/1/0/e/710ebeb5021c9798aaaf2a8a65dcea4b4c311caa.jpeg"
description: "First, Im not english native, and my english couldnt be 100% correct Over the time I learnt and used OOP classes in roblox using metatables, it was always a pain in the head to create some kind of superclasses that would work almost like roblox superclasses, and also were easy to set it up. It was relatively easy to inherit methods, but for properties that wasnt the case, I was copy-pasting the properties because I was lazy. that would work if you dont have that many classes, but if you have 5…"
url: "https://devforum.roblox.com/t/object-oriented-programming-oop-advanced-inheritance/1862382"
```

### receipes/ClassCreator
```embed
title: "ClassCreator - The tool for creating classes as a beginner"
image: "https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/5X/7/1/0/e/710ebeb5021c9798aaaf2a8a65dcea4b4c311caa.jpeg"
description: "ClassCreator The tool for creating OOP classes easily and 3 times more efficiently. Hello! I am receipes. Over the last year in programming in lua I have learnt lots of things about the language. Today, I am very excited to announce that today I am releasing a utility that I have been developping the last few weeks. I find it very useful and that’s why i’m showing it to you guys today. Let’s start! I will assume that you understand the basics of OOP and the terminology. If not then here are t…"
url: "https://devforum.roblox.com/t/classcreator-the-tool-for-creating-classes-as-a-beginner/2398045"
```

### Potato/BasicClass
```embed
title: "A Simple javascript-like luau class / Object Oriented Programming (OOP)"
image: "https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/5X/7/1/0/e/710ebeb5021c9798aaaf2a8a65dcea4b4c311caa.jpeg"
description: "Basic Class A simple luau class module. The basis of Object Oriented Programming TL;DR: It is simple and almost identical to the javascript class. Just use it: Why There are a lot of coding structures in the world. But In many games, The most formal, and standard structure is CLASS. There was no built-in Basis implementation of class in Luau. But now, We got a light, simple, and extendable module. It is a valuable option for structuring scripts as well as possible. Usage local Class…"
url: "https://devforum.roblox.com/t/a-simple-javascript-like-luau-class-object-oriented-programming-oop/2066466"
```

### Steven/ClassAbstractor
```embed
title: "Class Abstractor"
image: "https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/5X/7/1/0/e/710ebeb5021c9798aaaf2a8a65dcea4b4c311caa.jpeg"
description: "This is a class abstractor for object oriented programming. It simplifies the process of creating a class, extending classes, and even allows you to implement interfaces into the classes. Example usage: local Class = require(path.to.Class) local Animal = Class.NewClass():Implements({“number Health”, “number MaxHealth”, “BasePart RootPart”}) local Bear = Class.NewClass():Extends(Animal):Implements({“function Attack”}) function Animal:Constructor(health, rootPart) self.Health = health self.Ma…"
url: "https://devforum.roblox.com/t/class-abstractor/1617867"
```

### SpaceCube/FakeTable
```embed
title: "FakeTable: Supercharge your metatables"
image: "https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/5X/7/1/0/e/710ebeb5021c9798aaaf2a8a65dcea4b4c311caa.jpeg"
description: "The Scoop A while back, I created a custom table wrapper called FakeTable for my OOP library and ECS implementation (which was a terrible idea in hindsight). After forgetting about it for a month, I stumbled upon the wrapper again while reviewing old code and decided to make it a resource after some modifications. Ok, What Even is This Anyways? FakeTable serves as a table wrapper, intended to replicate the behaviors of metatables along with a few extra features. FakeTable adds two new custom…"
url: "https://devforum.roblox.com/t/faketable-supercharge-your-metatables/1445848"
```

### Eric/Classify
```embed
title: "Fetching"
image: "data:image/svg+xml;base64,PHN2ZyBjbGFzcz0ibGRzLW1pY3Jvc29mdCIgd2lkdGg9IjgwcHgiICBoZWlnaHQ9IjgwcHgiICB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAxMDAgMTAwIiBwcmVzZXJ2ZUFzcGVjdFJhdGlvPSJ4TWlkWU1pZCI+PGcgdHJhbnNmb3JtPSJyb3RhdGUoMCkiPjxjaXJjbGUgY3g9IjgxLjczNDEzMzYxMTY0OTQxIiBjeT0iNzQuMzUwNDU3MTYwMzQ4ODIiIGZpbGw9IiNlMTViNjQiIHI9IjUiIHRyYW5zZm9ybT0icm90YXRlKDM0MC4wMDEgNDkuOTk5OSA1MCkiPgogIDxhbmltYXRlVHJhbnNmb3JtIGF0dHJpYnV0ZU5hbWU9InRyYW5zZm9ybSIgdHlwZT0icm90YXRlIiBjYWxjTW9kZT0ic3BsaW5lIiB2YWx1ZXM9IjAgNTAgNTA7MzYwIDUwIDUwIiB0aW1lcz0iMDsxIiBrZXlTcGxpbmVzPSIwLjUgMCAwLjUgMSIgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiIGR1cj0iMS41cyIgYmVnaW49IjBzIj48L2FuaW1hdGVUcmFuc2Zvcm0+CjwvY2lyY2xlPjxjaXJjbGUgY3g9Ijc0LjM1MDQ1NzE2MDM0ODgyIiBjeT0iODEuNzM0MTMzNjExNjQ5NDEiIGZpbGw9IiNmNDdlNjAiIHI9IjUiIHRyYW5zZm9ybT0icm90YXRlKDM0OC4zNTIgNTAuMDAwMSA1MC4wMDAxKSI+CiAgPGFuaW1hdGVUcmFuc2Zvcm0gYXR0cmlidXRlTmFtZT0idHJhbnNmb3JtIiB0eXBlPSJyb3RhdGUiIGNhbGNNb2RlPSJzcGxpbmUiIHZhbHVlcz0iMCA1MCA1MDszNjAgNTAgNTAiIHRpbWVzPSIwOzEiIGtleVNwbGluZXM9IjAuNSAwIDAuNSAxIiByZXBlYXRDb3VudD0iaW5kZWZpbml0ZSIgZHVyPSIxLjVzIiBiZWdpbj0iLTAuMDYyNXMiPjwvYW5pbWF0ZVRyYW5zZm9ybT4KPC9jaXJjbGU+PGNpcmNsZSBjeD0iNjUuMzA3MzM3Mjk0NjAzNiIgY3k9Ijg2Ljk1NTE4MTMwMDQ1MTQ3IiBmaWxsPSIjZjhiMjZhIiByPSI1IiB0cmFuc2Zvcm09InJvdGF0ZSgzNTQuMjM2IDUwIDUwKSI+CiAgPGFuaW1hdGVUcmFuc2Zvcm0gYXR0cmlidXRlTmFtZT0idHJhbnNmb3JtIiB0eXBlPSJyb3RhdGUiIGNhbGNNb2RlPSJzcGxpbmUiIHZhbHVlcz0iMCA1MCA1MDszNjAgNTAgNTAiIHRpbWVzPSIwOzEiIGtleVNwbGluZXM9IjAuNSAwIDAuNSAxIiByZXBlYXRDb3VudD0iaW5kZWZpbml0ZSIgZHVyPSIxLjVzIiBiZWdpbj0iLTAuMTI1cyI+PC9hbmltYXRlVHJhbnNmb3JtPgo8L2NpcmNsZT48Y2lyY2xlIGN4PSI1NS4yMjEwNDc2ODg4MDIwNyIgY3k9Ijg5LjY1Nzc5NDQ1NDk1MjQxIiBmaWxsPSIjYWJiZDgxIiByPSI1IiB0cmFuc2Zvcm09InJvdGF0ZSgzNTcuOTU4IDUwLjAwMDIgNTAuMDAwMikiPgogIDxhbmltYXRlVHJhbnNmb3JtIGF0dHJpYnV0ZU5hbWU9InRyYW5zZm9ybSIgdHlwZT0icm90YXRlIiBjYWxjTW9kZT0ic3BsaW5lIiB2YWx1ZXM9IjAgNTAgNTA7MzYwIDUwIDUwIiB0aW1lcz0iMDsxIiBrZXlTcGxpbmVzPSIwLjUgMCAwLjUgMSIgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiIGR1cj0iMS41cyIgYmVnaW49Ii0wLjE4NzVzIj48L2FuaW1hdGVUcmFuc2Zvcm0+CjwvY2lyY2xlPjxjaXJjbGUgY3g9IjQ0Ljc3ODk1MjMxMTE5NzkzIiBjeT0iODkuNjU3Nzk0NDU0OTUyNDEiIGZpbGw9IiM4NDliODciIHI9IjUiIHRyYW5zZm9ybT0icm90YXRlKDM1OS43NiA1MC4wMDY0IDUwLjAwNjQpIj4KICA8YW5pbWF0ZVRyYW5zZm9ybSBhdHRyaWJ1dGVOYW1lPSJ0cmFuc2Zvcm0iIHR5cGU9InJvdGF0ZSIgY2FsY01vZGU9InNwbGluZSIgdmFsdWVzPSIwIDUwIDUwOzM2MCA1MCA1MCIgdGltZXM9IjA7MSIga2V5U3BsaW5lcz0iMC41IDAgMC41IDEiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiBkdXI9IjEuNXMiIGJlZ2luPSItMC4yNXMiPjwvYW5pbWF0ZVRyYW5zZm9ybT4KPC9jaXJjbGU+PGNpcmNsZSBjeD0iMzQuNjkyNjYyNzA1Mzk2NDE1IiBjeT0iODYuOTU1MTgxMzAwNDUxNDciIGZpbGw9IiNlMTViNjQiIHI9IjUiIHRyYW5zZm9ybT0icm90YXRlKDAuMTgzNTUyIDUwIDUwKSI+CiAgPGFuaW1hdGVUcmFuc2Zvcm0gYXR0cmlidXRlTmFtZT0idHJhbnNmb3JtIiB0eXBlPSJyb3RhdGUiIGNhbGNNb2RlPSJzcGxpbmUiIHZhbHVlcz0iMCA1MCA1MDszNjAgNTAgNTAiIHRpbWVzPSIwOzEiIGtleVNwbGluZXM9IjAuNSAwIDAuNSAxIiByZXBlYXRDb3VudD0iaW5kZWZpbml0ZSIgZHVyPSIxLjVzIiBiZWdpbj0iLTAuMzEyNXMiPjwvYW5pbWF0ZVRyYW5zZm9ybT4KPC9jaXJjbGU+PGNpcmNsZSBjeD0iMjUuNjQ5NTQyODM5NjUxMTc2IiBjeT0iODEuNzM0MTMzNjExNjQ5NDEiIGZpbGw9IiNmNDdlNjAiIHI9IjUiIHRyYW5zZm9ybT0icm90YXRlKDEuODY0NTcgNTAgNTApIj4KICA8YW5pbWF0ZVRyYW5zZm9ybSBhdHRyaWJ1dGVOYW1lPSJ0cmFuc2Zvcm0iIHR5cGU9InJvdGF0ZSIgY2FsY01vZGU9InNwbGluZSIgdmFsdWVzPSIwIDUwIDUwOzM2MCA1MCA1MCIgdGltZXM9IjA7MSIga2V5U3BsaW5lcz0iMC41IDAgMC41IDEiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiBkdXI9IjEuNXMiIGJlZ2luPSItMC4zNzVzIj48L2FuaW1hdGVUcmFuc2Zvcm0+CjwvY2lyY2xlPjxjaXJjbGUgY3g9IjE4LjI2NTg2NjM4ODM1MDYiIGN5PSI3NC4zNTA0NTcxNjAzNDg4NCIgZmlsbD0iI2Y4YjI2YSIgcj0iNSIgdHJhbnNmb3JtPSJyb3RhdGUoNS40NTEyNiA1MCA1MCkiPgogIDxhbmltYXRlVHJhbnNmb3JtIGF0dHJpYnV0ZU5hbWU9InRyYW5zZm9ybSIgdHlwZT0icm90YXRlIiBjYWxjTW9kZT0ic3BsaW5lIiB2YWx1ZXM9IjAgNTAgNTA7MzYwIDUwIDUwIiB0aW1lcz0iMDsxIiBrZXlTcGxpbmVzPSIwLjUgMCAwLjUgMSIgcmVwZWF0Q291bnQ9ImluZGVmaW5pdGUiIGR1cj0iMS41cyIgYmVnaW49Ii0wLjQzNzVzIj48L2FuaW1hdGVUcmFuc2Zvcm0+CjwvY2lyY2xlPjxhbmltYXRlVHJhbnNmb3JtIGF0dHJpYnV0ZU5hbWU9InRyYW5zZm9ybSIgdHlwZT0icm90YXRlIiBjYWxjTW9kZT0ic3BsaW5lIiB2YWx1ZXM9IjAgNTAgNTA7MCA1MCA1MCIgdGltZXM9IjA7MSIga2V5U3BsaW5lcz0iMC41IDAgMC41IDEiIHJlcGVhdENvdW50PSJpbmRlZmluaXRlIiBkdXI9IjEuNXMiPjwvYW5pbWF0ZVRyYW5zZm9ybT48L2c+PC9zdmc+"
description: "Fetching https://devforum.roblox.com/t/classify-a-simple-to-use-oop-super-constructor-for-class-driven-workflows/1219689"
url: "https://devforum.roblox.com/t/classify-a-simple-to-use-oop-super-constructor-for-class-driven-workflows/1219689"
```

### AstrealDev/RefinedClasses
```embed
title: "Refined Classes - Simplifying OOP in Lua"
image: "https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/5X/7/1/0/e/710ebeb5021c9798aaaf2a8a65dcea4b4c311caa.jpeg"
description: "What is Refined Classes? It’s a module I created that hugely simplifies replicating OOP in Lua. I’ve recently been working on a 2D Game Engine and I have an insane amount of classes & subclasses that each take a lot of time to create and decided to make this module. It simplified a tremendous amount of work I was doing and I believe it has a wide variety of uses. How do I use it? Here’s a pretty simple example of creating a projectile class and then giving it some properties. local RC = requ…"
url: "https://devforum.roblox.com/t/refined-classes-simplifying-oop-in-lua/1138129"
```
### torch/class
```embed
title: "GitHub - torch/class: Oriented Object Programming for Lua"
image: "https://opengraph.githubassets.com/9e4ee6ce3f173bae55f5d944ea9f43a32ef37ce75ed1afaafe34de676c6d2ba3/torch/class"
description: "Oriented Object Programming for Lua. Contribute to torch/class development by creating an account on GitHub."
url: "https://github.com/torch/class"
```

### google-deepmind/classic
```embed
title: "GitHub - google-deepmind/classic: A class system for Lua."
image: "https://opengraph.githubassets.com/d7105c81c46fed68a9b98ef626b83538e6e8555758e73b6e4e52e4cf28ce2334/google-deepmind/classic"
description: "A class system for Lua. Contribute to google-deepmind/classic development by creating an account on GitHub."
url: "https://github.com/google-deepmind/classic"
```

### rxi/classic
```embed
title: "GitHub - rxi/classic: Tiny class module for Lua"
image: "https://opengraph.githubassets.com/d410d9745ff17e7b5aa00053b4f7c98fa42437673e5d6ec6fb731bc8a8965745/rxi/classic"
description: "Tiny class module for Lua. Contribute to rxi/classic development by creating an account on GitHub."
url: "https://github.com/rxi/classic"
```

### kikito/stateful.lua
```embed
title: "GitHub - kikito/stateful.lua: Stateful classes for Lua"
image: "https://opengraph.githubassets.com/a7444ccc47c88388a691354930c17c947fda2cbfe618b04f7e08b1d5f3d087b2/kikito/stateful.lua"
description: "Stateful classes for Lua. Contribute to kikito/stateful.lua development by creating an account on GitHub."
url: "https://github.com/kikito/stateful.lua"
```

### jonstoler/class.lua
```embed
title: "GitHub - jonstoler/class.lua: object-oriented library for lua"
image: "https://opengraph.githubassets.com/c7376233dc246b84e69c9985723b2c464eeaa17fa43ebadf841438391be9880e/jonstoler/class.lua"
description: "object-oriented library for lua. Contribute to jonstoler/class.lua development by creating an account on GitHub."
url: "https://github.com/jonstoler/class.lua"
```

### Yonoba/Lua Class System
```embed
title: "GitHub - Yonaba/Lua-Class-System: Lua Class System (LCS) is a small library which offers a clean, minimalistic but powerful API for (Pseudo) Object Oriented programming style using Lua."
image: "https://opengraph.githubassets.com/c592df5b71fa1926571907712314690c0e60b0ac8dbae651336cd6377c6fe180/Yonaba/Lua-Class-System"
description: "Lua Class System (LCS) is a small library which offers a clean, minimalistic but powerful API for (Pseudo) Object Oriented programming style using Lua. - Yonaba/Lua-Class-System"
url: "https://github.com/Yonaba/Lua-Class-System"
```

## OOP Guides in Lua(u)
### Advanced Object-Oriented Programming - Bit
```embed
title: "Advanced Object-Oriented Programming"
image: "https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/optimized/5X/c/6/5/5/c655eefc541f4329fd7cfd84d73954f7c67888e7_2_1024x819.png"
description: "Advanced Object-Oriented Programming A Senior’s Guide to Object-Oriented Programming in Luau. Originally Written by Bitlet Table of Contents Introduction Prerequisites Luau Object-Oriented Programming Creating an Interface Basic Structure Static Methods Instance Method Declarations Creating an Abstract Class Basic Structure Initialized Instance Methods Static Variables Instance Variables Access Specifiers Public Protected Private Creating a Class The Construc…"
url: "https://devforum.roblox.com/t/advanced-object-oriented-programming/3103453"
```

### 3 Different OOP Approaches - LyingYouLou
```embed
title: "3 Different OOP approaches: performance, memory consumption, and aesthetics"
image: "https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/5X/7/1/0/e/710ebeb5021c9798aaaf2a8a65dcea4b4c311caa.jpeg"
description: "Figuring out what OOP implementation works best for you can be difficult since Lua(u) is such a flexible language. In Roblox, the idiomatic way to implement OOP is via metatables. This approach has been shown to be memory-efficient, albeit somewhat slower in the Lua community. However, Luau can be very different from normal Lua and the gap is only getting wider. Therefore, I see it as necessary to run performance tests without relying on Lua benchmarks of questionable relevance. I have implemen…"
url: "https://devforum.roblox.com/t/3-different-oop-approaches-performance-memory-consumption-and-aesthetics/1601163"
```
## OOP Tooling in Lua(u)
### R2Z/ClassInserter
```embed
title: "RZS’s Class Inserter - Creating class ModuleScripts made easy"
image: "https://devforum-uploads.s3.dualstack.us-east-2.amazonaws.com/uploads/original/4X/f/6/2/f6264fed8e91924436af324b00f10e8c4f39082c.png"
description: "RZS’s Class Inserter Plugin Tired of typing the same snippets of code every time when you’re creating a new class ModuleScript? This plugin may be for you. Features Small, non-intrusive UI. One toolbar button, one widget, no unnecessary prints Studio theme syncing Subclassing support Custom, fully editable and highly flexible template system Using the plugin To create a new ModuleScript, open the main GUI and input a class name. Additionally, input any constructor parameters (comma-separate…"
url: "https://devforum.roblox.com/t/rzss-class-inserter-creating-class-modulescripts-made-easy/736038"
```
