package com.wehaverhythm.carousel
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Ease;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Sine;
	import com.wehaverhythm.starling.utils.CustomEvent;
	import com.wehaverhythm.utils.ArrayUtils;
	import com.wehaverhythm.utils.IDestroyable;
	
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	public class Carousel3D extends Sprite implements IDestroyable
	{
		private var circle:CirclePath3D;
		private var settings:Object;
		private var rotationOffset:Number;
		
		private var currentAngle:Number;
		private var increment:Number;
		
		private var items:Array;
		private var itemFollowers:Array;
		private var numItems:int;
		private var currentItem:int = 0;
		
		private var targAngle:Number = 0;
		private var t:TweenLite;
		private var rotateTime:Number = .6;
		private var ease:Ease = Quad.easeInOut;		
		
		private var distBounds:Object;
		private var distance:Number;
		private var alphaEnabled:Boolean;
		private var currentPosition:int = 0;
		
		private var itemsHarness:Sprite;
		private var itemsCopy:Array;
		
		private var stage:Stage;
		private var swipedX:Number;
		
		
		public function Carousel3D()
		{
			super();			
		}
		
		public function init(items:Array, settings:Object):void
		{
			this.items = items;			
			itemsCopy = ArrayUtils.copyArray(this.items);
			this.settings = settings;
			
			rotateTime = 0.6;
			rotationOffset = settings.rotationOffset;
			
			stage = Starling.current.stage;			
			
			distBounds = new Object();
			distBounds.front = -settings.radius;
			distBounds.back = settings.radius;
			distance = distBounds.back - distBounds.front;
			
			itemsHarness = new Sprite();
			itemsHarness.scaleX = itemsHarness.scaleY = itemsHarness.alpha = 0;
			addChild(itemsHarness);
			
			initItems();
			initCircle();
		}
		
		private function onStageTouch(e:TouchEvent):void
		{
			if (e.touches[0].phase == TouchPhase.MOVED)
			{
				swipedX = e.touches[0].globalX - e.touches[0].previousGlobalX;
				if (swipedX > settings.swipeDistance) left();
				if (swipedX < -settings.swipeDistance) right();
			}
		}
		
		private function initItems():void
		{
			numItems = items.length;
			increment = 360 / items.length;
			
			for (var i:int=0; i < numItems; ++i)
			{
				var pp:PerspectiveProjection=new PerspectiveProjection();
				pp.projectionCenter = new Point(0, 0);
				
				items[i].y = 0;
				items[i].position = i;					
				itemsHarness.addChild(items[i]);
			}
			
			addEventListener('CAROUSEL_ITEM_CLICKED', onCarouselItemClicked);
		}
		
		private function onCarouselItemClicked(e:CustomEvent):void
		{
			jumpToItem(e.data.id);
		}
		
		public function show(quick:Boolean=false):void
		{
			stage.addEventListener(TouchEvent.TOUCH, onStageTouch);
			TweenMax.to(itemsHarness, quick ? .4 : .6, {alpha:1, scaleX:1, scaleY:1, ease:Sine.easeOut});
		}
		
		public function hide():void
		{
			stage.removeEventListener(TouchEvent.TOUCH, onStageTouch);
			TweenMax.to(itemsHarness, .7, {alpha:0, scaleX:0, scaleY:0, ease:Sine.easeIn});
		}
		
		private function initCircle():void
		{
			circle = new CirclePath3D(0, 0, settings.radius, settings.lift)
			
			var angle:int =  0;			
			itemFollowers = new Array();
			
			for(var i:int=0; i < numItems; ++i)
			{
				itemFollowers[i] = circle.addFollower(items[i], circle.angleToProgress(angle));
				angle += increment;
			}
			
			circle.rotation = -90 + rotationOffset;
			currentAngle = circle.rotation;
			
			onCircleUpdate();
		}
		
		public function left(masked:* = null):void
		{
			if(t) return;
			
			trace("do spin left");
			
			if(masked) masked.cacheAsBitmap = true;
			
			currentItem --;
			currentPosition --;
			shiftItemsLeft();
			if(currentItem < 0) currentItem = numItems-1;
			
			currentAngle = circle.rotation + increment;
			
			t = TweenLite.to(circle, rotateTime, {rotation:currentAngle, onUpdate:onCircleUpdate, onComplete:onRotateComplete, ease:ease, overwrite:3});
		}
		
		public function right(masked:* = null):void
		{
			if(t) return;
			
			trace("do spin right");
			
			if(masked) masked.cacheAsBitmap = true;
			
			currentItem ++;
			currentPosition ++;
			shiftItemsRight();
			if(currentItem == numItems) currentItem = 0;
			
			currentAngle = circle.rotation - increment;
			
			t = TweenLite.to(circle, rotateTime, {rotation:currentAngle, onUpdate:onCircleUpdate, onComplete:onRotateComplete, ease:ease, overwrite:3});
		}
		
		private function shiftItemsLeft(count:int = 1):void
		{
			for (var i:int = 0; i < items.length; ++i)
			{
				items[i].position += count;
				
				if (items[i].position >= numItems)
				{
					var diff:int = items[i].position - numItems;
					items[i].position = diff;
				}
			}
		}
		
		private function shiftItemsRight(count:int = 1):void
		{
			for(var i:int = 0; i < items.length; ++i)
			{
				items[i].position -= count;				
				if (items[i].position < 0) items[i].position = (numItems + items[i].position);
			}
		}
		
		public function jumpToItem(nextItem:int):void
		{
			// interrupt tween.
			if(t) return;
			
			if(nextItem == currentItem)
			{
				// nowhere to move to!
				onRotateComplete();
				dispatchEvent(new CustomEvent('CAROUSEL_ITEM_ACTIVATED', {item:items[currentItem]}));
				return;
			}
			
			var idDiff:int = items[nextItem].position - items[currentItem].position; 
			var left:Boolean = true;
			
			if(items[nextItem].x < 0)
			{
				idDiff = items.length - idDiff;	
				
				currentPosition -= idDiff;
				shiftItemsLeft(idDiff);
				currentItem -= idDiff;
				
				if(currentItem < 0) {
					currentItem = (numItems + currentItem);
				}
				
				currentAngle = circle.rotation + (increment*idDiff);
				
			} else {
				
				currentPosition += idDiff;
				currentItem += idDiff;
				shiftItemsRight(idDiff);
				
				
				if(currentItem >= numItems) {
					var diff:int = currentItem - numItems;
					currentItem = diff;
				}
				
				currentAngle = circle.rotation - (increment*idDiff);				
			}
			
			t = TweenLite.to(circle, rotateTime+(idDiff/10), {rotation:currentAngle, onUpdate:onCircleUpdate, onComplete:onRotateComplete, ease:ease, overwrite:3});
			
		}
		
		private function onCircleUpdate():void
		{
			var itemProgress:Number;
			
			// calculate blue
			for (var i:int = 0; i < numItems; ++i)
			{
				itemProgress = getDistanceProgress(i);
				if (settings.backAlpha != null) applyItemAlpha(items[i], itemProgress);
				applyItemScale(items[i], itemProgress/settings.backScale);
			}
			
			// z sort!
			zSortItems();
		}
		
		private function zSortItems():void
		{			
			for each (var item:MenuItem in itemsCopy)
			{
				item.bottom = item.y + item.height;
			}			
			
			itemsCopy.sortOn('bottom', Array.NUMERIC);
			
			for (var i:int=0; i<itemsCopy.length; ++i)
			{
				itemsHarness.addChild(itemsCopy[i]);
			}
		}
		
		private function applyItemScale(item:*, amount:*):void
		{
			var maxScaleAmount:Number = .3;
			item.scaleX = item.scaleY = 1-(maxScaleAmount*amount);
		}
		
		private function applyItemAlpha(item:*, amount:*):void
		{
			item.alpha = (1-amount)+settings.backAlpha;
		}
		
		private function onRotateComplete():void
		{	
			t = null;
			dispatchEvent(new CustomEvent("TURN_COMPLETE"));
		}
		
		private function getDistanceProgress(id:int):Number
		{
			return (items[id].z / distance) + .5;
		}
		
		public function destroy():void
		{
			removeEventListener('CAROUSEL_ITEM_CLICKED', onCarouselItemClicked);
			stage.removeEventListener(TouchEvent.TOUCH, onStageTouch);
			
			t = null;
			TweenMax.killTweensOf(this);
			TweenMax.killTweensOf(itemsHarness);
			
			while (items.length) 
			{
				items[0].destroy();
				items[0].dispose();
				items[0] = null;
				items.shift();
			}
			items = null;			
			
			while (itemsCopy.length) 
			{
				itemsCopy[0] = null;
				itemsCopy.shift();
			}
			itemsCopy = null;
			
			settings = null;
			
			stage = null;			
			distBounds = null;
			
			removeChild(itemsHarness);
			itemsHarness.dispose();
			itemsHarness = null;
			
			circle.removeAllFollowers();
			circle = null;
			
			while (itemFollowers.length)
			{
				itemFollowers[0] = null;
				itemFollowers.shift();
			}
			itemFollowers = null;
		}
	}
}
import com.wehaverhythm.carousel;

