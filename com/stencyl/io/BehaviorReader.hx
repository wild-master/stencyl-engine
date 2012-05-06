package com.stencyl.io;

import haxe.xml.Fast;
import com.stencyl.models.Resource;
import com.stencyl.behavior.Behavior;
import com.stencyl.behavior.Attribute;

class BehaviorReader
{
	public function new() 
	{
	}		

	public static function readBehavior(xml:Fast):Behavior
	{
		var elementID:Int = Std.parseInt(xml.att.id);
		var name:String = xml.att.name;
		var classname:String = xml.att.classname;
		var attributes:Hash<Attribute> = new Hash<Attribute>();
		var type:String = xml.att.type;
	
		for(e in xml.elements)
		{
			var type:String = e.name;
			
			if(type == "snippets")
			{
				//Sub-Snippets - Ignore
			}
			
			else if(type == "blocks")
			{
				//Custom Blocks - Ignore for engine
			}
			
			else if(type == "events")
			{
				//Events - Ignore for engine
			}
			
			//Attributes
			else
			{
				attributes.set(e.att.id, readAttribute(e));	
			}
		}
		
		var b:Behavior = new Behavior
		(
			null,
			null,
			elementID,
			name,
			classname, 
			true,
			true,
			attributes,
			type
		);

		return b;
	}
	
	public static function readAttribute(xml:Fast):Attribute
	{
		var ID:Int = Std.parseInt(xml.att.id);
		var fieldName:String = xml.att.name;
		var fullName:String = xml.att.fullname;
		var defaultValue:String = xml.att.defaultValue;
		var type:String = xml.name;
		
		return new Attribute(ID, fieldName, fullName, defaultValue, type, null);
	}
}
