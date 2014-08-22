package com.wehaverhythm.starling.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	
	public class StarlingUtils
	{
		public function StarlingUtils()
		{			
		}
		
		public static function imageFromDisplayObject(obj:DisplayObject):Image
		{		
			var bmd:BitmapData = new BitmapData(obj.width, obj.height, true, 0x000000);
			bmd.draw(obj);		
			
			return StarlingUtils.imageFromBitmapData(bmd);
		}
		
		public static function imageFromBitmapData(bmd:BitmapData):Image
		{
			var bmp:Bitmap = new Bitmap(bmd);
			var texture:Texture = Texture.fromBitmap(new Bitmap(bmd), false, false, 1);	
			
			bmd.dispose();
			bmp = null;
			bmd = null;
			
			return new Image(texture);
		}
		
		public static function imageFromBitmap(bmp:Bitmap):Image
		{
			var texture:Texture = Texture.fromBitmap(bmp, false, false, 1);	
			
			bmp.bitmapData.dispose;
			bmp = null;
			
			return new Image(texture);
		}
		
		public static function textureFromDisplayObject(obj:DisplayObject):Texture
		{		
			var bmd:BitmapData = new BitmapData(obj.width, obj.height, true, 0x000000);
			bmd.draw(obj);		
			
			var texture:Texture = Texture.fromBitmapData(bmd, false, false, 1);
			
			bmd.dispose();
			bmd = null;
			
			return texture;
		}
	}
}