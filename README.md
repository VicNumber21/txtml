TxtML
=====

### Build status
[![Build Status](https://travis-ci.org/VicNumber21/txtml.png)](https://travis-ci.org/VicNumber21/txtml)

###Overview
The project was inspired by [js sequence diagrams project]
(http://bramp.github.io/js-sequence-diagrams).

The main goal of the project is to extend a text definition approach to all useful UML diagrams:
- class diagram
- state diagram
- collaboration / sequence diagram

Another types of UML diagrams may be supported as well.

Ideally, the target is to create a simple text-based language for architecture notes
which may be rendered in a pretty manner and shared with others.
It can be build using Markdown (extended probably) together with TxtML to
define / render an architecture document.

To reach this goal, TxtML should split an architecture definition part from
an architecture representation one. The user of TxtML should be able to
describe the architecture and the way he wants to represent it: views, layouts
and etc.

###Roadmap
The current roadmap is the following:
- 0.0.x - Proof of Concept
- 0.1.x - Infrastructure
- 0.2.x - Data Structures
- 0.3.x - Graph Utils
- 0.4.x - Class Diagram - Basic
- 0.5.x - State Diagram - Basic
- 0.6.x - Collaboration Diagram - Basic
- 0.8.x - Sequence Diagram - Basic
- 0.10.x - Views and Simple Layouts
- 1.0.0 - TxtML - Basic

### License
Simplified BSD License

Syntax
------
###Class diagram
### Description
Class diagram description consists of several lines.
Each line represents a relationship between two classes.

A line looks as the following:
```Class1 <relationship> Class2```

#### Example
The "Decorator" design patter description may look as the following:
```
Component |>-- Decorator
ConcreteComponent --<| Component
Decorator |>-- ConcreteDecorator
Component <--<> Decorator
```

On [project official page](http://vicnumber21.github.io/txtml) you may find
a live demo with this example (no real UML there though since it is a proof of
concept still).

#### Relationships
At the moment the following relationships are supported:
- ```|>--```, ```--<|``` - generalization
- ```<>-->```, ```<--<>``` - aggregation
- ```<|>-->```, ```<--<|>``` - composition
- ```- ->```, ```<- -``` - dependency
