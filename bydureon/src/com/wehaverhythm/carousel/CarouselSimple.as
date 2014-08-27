package com.wehaverhythm.carousel
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Ease;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Sine;
	import com.greensock.plugins.BezierThroughPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.wehaverhythm.starling.utils.CustomEvent;
	import com.wehaverhythm.utils.ArrayUtils;
	import com.wehaverhythm.utils.IDestroyable;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	public class CarouselSimple extends Sprite implements IDestroyable
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
		
		
		public function CarouselSimple()
		{
			super();	
			TweenPlugin.activate([BezierThroughPlugin]);
		}
		
		public function init(items:Array, settings:Object):void
		{
			this.items = items;			
			itemsCopy = ArrayUtils.copyArray(this.items);
			this.settings = settings;
			
			rotateTime = 0.6;
			rotationOffset = settings.rotationOffset;
			
			stage = Starling.current.stage;			
			
			itemsHarness = new Sprite();
			itemsHarness.scaleX = itemsHarness.scaleY = itemsHarness.alpha = 0;
			addChild(itemsHarness);
		
			initItems();
			show(true);
		}
		
		private function onStageTouch(e:TouchEvent):void
		{
			if (e.touches[0].phase == TouchPhase.MOVED)
			{
				swipedX = e.touches[0].globalX - e.touches[0].previousGlobalX;
				if (swipedX > settings.swipeDistance) right();
				if (swipedX < -settings.swipeDistance) left();
			}
		}
		
		private function initItems():void
		{
			numItems = items.length;
			increment = 360 / items.length;
			
			for (var i:int=0; i < numItems; ++i)
			{
				items[i].x = settings.carousel.points[i].x - x;
				items[i].y = settings.carousel.points[i].y - y;
				items[i].scaleX = items[i].scaleY = settings.carousel.points[i].scale;
				items[i].position = i;					
				itemsHarness.addChild(items[i]);
			}
			
			zSortItems();
			
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
		
		public function left(masked:* = null):void
		{
			if (t) return;
			
			trace("do spin left");			
			if (masked) masked.cacheAsBitmap = true;
			
			shiftItemsLeft();
		}
		
		public function right(masked:* = null):void
		{
			if (t) return;
			
			trace("do spin right");			
			if (masked) masked.cacheAsBitmap = true;
			
			shiftItemsRight();			
		}
		
		private function shiftItemsRight(count:int = 1):void
		{
			for(var i:int = 0; i < items.length; ++i)
			{				
				var path:Array = [];
				
				for (var j:int=1; j <= count; ++j)
				{
					var nextPoint:int = items[i].position+j;
					
					if (nextPoint >= numItems)
					{
						var diff:int = nextPoint - numItems;
						nextPoint = diff;
					}
					
					path.push({
						x:settings.carousel.points[nextPoint].x-x, 
						y:settings.carousel.points[nextPoint].y-y, 
						scaleX:settings.carousel.points[nextPoint].scale, 
						scaleY:settings.carousel.points[nextPoint].scale
					});
				}		
				
				// update item position
				items[i].position += count;
				
				if (items[i].position >= numItems)
				{
					diff = items[i].position - numItems;
					items[i].position = diff;
				}
				
				// do bezier through tween
				t = TweenMax.to(items[i], rotateTime, {bezierThrough:path, ease:ease, onUpdate:zSortItems, onComplete:onRotateComplete, overwrite:3}); 
			}		
			
			// update current item
			currentItem -= count;
			
			if (currentItem < 0)
			{
				diff = currentItem + numItems;
				currentItem = diff;
			}
		}
		
		private function shiftItemsLeft(count:int = 1):void
		{
			for(var i:int = 0; i < items.length; ++i)
			{				
				var path:Array = [];
				
				for (var j:int=1; j <= count; ++j)
				{
					var nextPoint:int = items[i].position-j;
					
					if (nextPoint < 0)
					{
						var diff:int = nextPoint + numItems;
						nextPoint = diff;
					}
					
					path.push({
						x:settings.carousel.points[nextPoint].x-x, 
						y:settings.carousel.points[nextPoint].y-y, 
						scaleX:settings.carousel.points[nextPoint].scale, 
						scaleY:settings.carousel.points[nextPoint].scale
					});
				}		
				
				// update item position
				items[i].position -= count;
				
				if (items[i].position < 0)
				{
					diff = items[i].position + numItems;
					items[i].position = diff;
				}
				
				// do bezier through tween
				t = TweenMax.to(items[i], rotateTime, {bezierThrough:path, ease:ease, onUpdate:zSortItems, onComplete:onRotateComplete, overwrite:3}); 
			}
			
			// update current item
			currentItem += count;
			
			if (currentItem >= numItems)
			{
				diff = currentItem - numItems;
				currentItem = diff;
			}
		}
		
		public function jumpToItem(nextItem:int):void
		{
			// interrupt tween.
			if(t) return;
			
			trace('nextItem:', nextItem, 'currentItem:', currentItem, 'nextItem position:', items[nextItem].position);
			
			if (items[nextItem].position == 0)
			{
				onRotateComplete();
				dispatchEvent(new CustomEvent('CAROUSEL_ITEM_ACTIVATED', {item:items[nextItem]}));
				return;
			}
			
			if (items[nextItem].x > 0) shiftItemsLeft(items[nextItem].position);
			else shiftItemsRight(numItems - items[nextItem].position);	
		}
		
		private function zSortItems():void
		{			
			for each (var item:SimpleMenuItem in itemsCopy)
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

