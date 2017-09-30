# Godot-QuadTree
2d QuadTree implementation for Godot Engine

I wrote this to familiarize myself with Godot Engine and GDScript.  It is not a complete QuadTree solution, just a basic one intended for education.

# Usage
See Scripts/QuadTreeDemo.gd for example usage

QuadTree class permits any object that derives from the Spatial node.  Simply call add_body(yourObject) and the object will be added and QuadTree splits as necessary.

A simple function to query the QuadTree requires a a circle's center point and radius.  Any QuadTree quadrant that may overlap the circle will add its child objects to the query result.
