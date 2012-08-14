package com.stencyl.graphics.transitions;

import nme.geom.Point;
import nme.geom.Rectangle;
import nme.display.Sprite;
import nme.display.Graphics;
import nme.display.BitmapData;
import nme.display.Shape;

import com.stencyl.Engine;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Linear;

class BubblesTransition extends Transition
{
	public var color:Int;
	public var numBubbles:Int;
		
	//needs to be public so that it can be tweened
	public var radius:Float;
		
	private var beginRadius:Float;
	private var endRadius:Float;
	
	private var rect:Shape;
	private var graphics:Graphics;
	private var drawBitmap:BitmapData;
	
	private var bubblePositions:Array<Point>;
	private var bubbleRect:Rectangle;
		
	public function new(direction:String, duration:Float, numBubbles:Int = 50, color:Int = 0xff000000) 
	{
		super(duration);
			
		this.color = color;
		this.direction = direction;
		this.numBubbles = numBubbles;
	}
	
	override public function start()
	{
		active = true;
		
		rect = new Shape();
		graphics = rect.graphics;
		
		if (direction == Transition.IN)
		{
			graphics.beginFill(color);
			graphics.drawRect(0, 0, Engine.screenWidth, Engine.screenHeight);
			graphics.endFill();
		}		
		
		drawBitmap = new BitmapData(Engine.screenWidth, Engine.screenHeight);		
		
		var screenRatio:Float = Engine.screenWidth / Engine.screenHeight;
		var vertBubbles:Int = Std.int(Math.sqrt(numBubbles / screenRatio));
		var horzBubbles:Int = Std.int(vertBubbles * screenRatio);
		var bubbleSize:Float = Engine.screenHeight / vertBubbles;
			
		var c:Int = Math.ceil(horzBubbles);
		var r:Int = Math.ceil(vertBubbles);
			
		var xOverflow:Int = Std.int(c * bubbleSize - Engine.screenWidth);
		var yOverflow:Int = Std.int(r * bubbleSize - Engine.screenHeight);
			
		var bubbleRect:Rectangle = new Rectangle(-xOverflow / 2, -yOverflow / 2, bubbleSize, bubbleSize);
			
		bubblePositions = new Array<Point>();
			
		for(i in 0...r)
		{
			for(j in 0...c)
			{
				//plant a bubble randomly
				bubblePositions.push(new Point(bubbleRect.x + Math.floor(Math.random() * (bubbleSize + 1)), bubbleRect.y + Math.floor(Math.random() * (bubbleSize + 1))));
				bubbleRect.x += bubbleSize;
			}
			
			bubbleRect.x = -xOverflow / 2;
			bubbleRect.y += bubbleSize;
		}
			
		beginRadius = 0; 
		endRadius = Math.ceil(Point.distance(new Point(0, 0), new Point(bubbleSize, bubbleSize)));
			
		radius = beginRadius;
		
		Engine.engine.transitionLayer.addChild(rect);
		
		Actuate.tween(this, duration, { radius:endRadius} ).ease(Linear.easeNone).onComplete(stop);
	}
	
	override public function draw(g:Graphics)
	{
		graphics.clear();
			
		if(direction == Transition.IN)
		{
			drawBitmap.draw(Engine.engine.master);
			
			graphics.beginFill(color);
			graphics.drawRect(0, 0, Engine.screenWidth, Engine.screenHeight);
			graphics.endFill();
			
			for (p in bubblePositions)
			{
				graphics.beginBitmapFill(drawBitmap);
				graphics.drawCircle(p.x, p.y, radius);
				graphics.endFill();
			}
		}
		else if(direction == Transition.OUT)
		{
				
			for (p in bubblePositions)
			{
				graphics.beginFill(color);
				graphics.drawCircle(p.x, p.y, radius);
				graphics.endFill();
			}
		}		
	}
	
	override public function cleanup()
	{		
		if(rect != null)
		{
			Engine.engine.transitionLayer.removeChild(rect);
			rect = null;
		}
	}
	
}