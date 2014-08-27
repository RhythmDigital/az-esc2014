package com.wehaverhythm.starling.utils
{	
	import com.wehaverhythm.utils.IDestroyable;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	
	public class SmartImage extends Image implements IDestroyable
	{	
		// scaling factor for cached texture (0.01-1)
		private var scaling:Number;
		
		// cached texture
		private var bitmapCache:BitmapData;
		
		// threshold alpha value for touch events to occur (0-255)	
		public var alphaCutoff:int = 32;
		
		
		public function SmartImage(bitmap:Bitmap, scaling:Number=0.5)
		{
			this.scaling = Math.max(scaling, .01);
			this.scaling = Math.min(scaling, 1);
			cacheData(bitmap);
			super( Texture.fromBitmap(bitmap) );
		}
		
		// scale down and cache the texture data
		private function cacheData(bmp:Bitmap):void
		{
			// prepare the cached texture
			var w:int = Math.ceil(bmp.width * scaling);
			var h:int = Math.ceil(bmp.height * scaling);
			bitmapCache = new BitmapData(w,h,true,0);
			
			// call .draw() uses Flash's renderer for the scaling
			var scaleMatrix:Matrix = new Matrix();
			scaleMatrix.scale(scaling,scaling);
			bitmapCache.draw(bmp, scaleMatrix);
		}
		
		// do a hit test for a touch event
		public override function hitTest(localPoint:Point, forTouch:Boolean=false):DisplayObject
		{
			// test fails if the object is invisible or not touchable
			if (forTouch && (!visible || !touchable)) { return null; }
			
			// likewise if touch is outside bounds of the object
			if (! getBounds(this).containsPoint(localPoint)) { return null; }
			
			// call a Starling helper function to find the alpha value at the event x,y
			var color:uint = bitmapCache.getPixel32(localPoint.x*scaling, localPoint.y*scaling);
			if (Color.getAlpha(color) > alphaCutoff) {
				return this; // a hit occurred!
			} else {
				return null;
			}
		}
		
		public function destroy():void
		{
			bitmapCache.dispose();
			bitmapCache = null;
		}
	}
}