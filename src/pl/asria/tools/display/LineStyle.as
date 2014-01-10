package pl.asria.tools.display 
{
	/**
	 * ...
	 * @author Piotr Paczkowski - kontakt@trzeci.eu
	 */
	public class LineStyle 
	{
		public var thickness:Number;
		public var color:uint;
		public var alpha:Number;
		public var pixelHinting:Boolean;
		public var scaleMode:String;
		public var caps:String;
		public var joints:String;
		public var miterLimit:Number;
		
		/**
		 * Adobe Descryption:
		 * Specifies a line style used for subsequent calls to 
		 * Graphics methods such as the lineTo() method or the drawCircle() method. 
		 * The line style remains in effect until you call the lineGradientStyle() 
		 * method, the lineBitmapStyle() method, or the lineStyle() method with different parameters.
		 * 
		 *   You can call the lineStyle() method in the middle of drawing a path to specify different 
		 * styles for different line segments within the path.Note: Calls to the clear() method set the line style back to 
		 * undefined.Note: Flash Lite 4 supports only the first three parameters (thickness, color, and alpha).
		 * @param	thickness	An integer that indicates the thickness of the line in 
		 *   points; valid values are 0-255. If a number is not specified, or if the 
		 *   parameter is undefined, a line is not drawn. If a value of less than 0 is passed, 
		 *   the default is 0. The value 0 indicates hairline thickness; the maximum thickness 
		 *   is 255. If a value greater than 255 is passed, the default is 255.
		 * @param	color	A hexadecimal color value of the line; for example, red is 0xFF0000, blue is 
		 *   0x0000FF, and so on. If a value is not indicated, the default is 0x000000 (black). Optional.
		 * @param	alpha	A number that indicates the alpha value of the color of the line; 
		 *   valid values are 0 to 1. If a value is not indicated, the default is 1 (solid). If 
		 *   the value is less than 0, the default is 0. If the value is greater than 1, the default is 1.
		 * @param	pixelHinting	(Not supported in Flash Lite 4) A Boolean value that specifies whether to hint strokes 
		 *   to full pixels. This affects both the position of anchors of a curve and the line stroke size 
		 *   itself. With pixelHinting set to true, line widths are adjusted  
		 *   to full pixel widths. With pixelHinting set to false, disjoints can 
		 *   appear for curves and straight lines. For example, the following illustrations show how 
		 *   Flash Player or Adobe AIR renders two rounded rectangles that are identical, except that the 
		 *   pixelHinting parameter used in the lineStyle() method is set 
		 *   differently (the images are scaled by 200%, to emphasize the difference):
		 *   
		 *     If a value is not supplied, the line does not use pixel hinting.
		 * @param	scaleMode	(Not supported in Flash Lite 4) A value from the LineScaleMode class that 
		 *   specifies which scale mode to use:
		 *   
		 *     LineScaleMode.NORMAL—Always scale the line thickness when the object is scaled 
		 *   (the default).
		 *   LineScaleMode.NONE—Never scale the line thickness.
		 *   LineScaleMode.VERTICAL—Do not scale the line thickness if the object is scaled vertically 
		 *   only. For example, consider the following circles, drawn with a one-pixel line, and each with the 
		 *   scaleMode parameter set to LineScaleMode.VERTICAL. The circle on the left 
		 *   is scaled vertically only, and the circle on the right is scaled both vertically and horizontally:
		 *   
		 *     LineScaleMode.HORIZONTAL—Do not scale the line thickness if the object is scaled horizontally 
		 *   only. For example, consider the following circles, drawn with a one-pixel line, and each with the 
		 *   scaleMode parameter set to LineScaleMode.HORIZONTAL. The circle on the left 
		 *   is scaled horizontally only, and the circle on the right is scaled both vertically and horizontally:
		 * @param	caps	(Not supported in Flash Lite 4) A value from the CapsStyle class that specifies the type of caps at the end 
		 *   of lines. Valid values are: CapsStyle.NONE, CapsStyle.ROUND, and CapsStyle.SQUARE. 
		 *   If a value is not indicated, Flash uses round caps. 
		 *   For example, the following illustrations show the different capsStyle 
		 *   settings. For each setting, the illustration shows a blue line with a thickness of 30 (for 
		 *   which the capsStyle applies), and a superimposed black line with a thickness of 1 
		 *   (for which no capsStyle applies):
		 * @param	joints	(Not supported in Flash Lite 4) A value from the JointStyle class that specifies the type of joint appearance
		 *   used at angles. Valid 
		 *   values are: JointStyle.BEVEL, JointStyle.MITER, and JointStyle.ROUND.
		 *   If a value is not indicated, Flash uses round joints.
		 *   
		 *     For example, the following illustrations show the different joints 
		 *   settings. For each setting, the illustration shows an angled blue line with a thickness of 
		 *   30 (for which the jointStyle applies), and a superimposed angled black line with a 
		 *   thickness of 1 (for which no jointStyle applies):
		 *   Note: For joints set to JointStyle.MITER, 
		 *   you can use the miterLimit parameter to limit the length of the miter.
		 * @param	miterLimit	(Not supported in Flash Lite 4) A number that indicates the limit at which a miter is cut off. 
		 *   Valid values range from 1 to 255 (and values outside that range are rounded to 1 or 255). 
		 *   This value is only used if the jointStyle 
		 *   is set to "miter". The 
		 *   miterLimit value represents the length that a miter can extend beyond the point
		 *   at which the lines meet to form a joint. The value expresses a factor of the line
		 *   thickness. For example, with a miterLimit factor of 2.5 and a 
		 *   thickness of 10 pixels, the miter is cut off at 25 pixels.
		 *   
		 *     For example, consider the following angled lines, each drawn with a thickness 
		 *   of 20, but with miterLimit set to 1, 2, and 4. Superimposed are black reference
		 *   lines showing the meeting points of the joints:Notice that a given miterLimit value has a specific maximum angle 
		 *   for which the miter is cut off. The following table lists some examples:miterLimit value:Angles smaller than this are cut off:1.41490 degrees260 degrees430 degrees815 degrees
		 * @langversion	3.0
		 * @playerversion	Flash 9
		 * @playerversion	Lite 4
		 * @maelexample	The following code draws a triangle with a 5-pixel, solid magenta line with 
		 *   no fill, with pixel hinting, no stroke scaling, no caps, and miter joints with 
		 *   <code>miterLimit</code> set to 1:
		 *   
		 *     <listing>
		 *   this.createEmptyMovieClip("triangle_mc", this.getNextHighestDepth());
		 *   triangle_mc.lineStyle(5, 0xff00ff, 100, true, "none", "round", "miter", 1);
		 *   triangle_mc.moveTo(200, 200);
		 *   triangle_mc.lineTo(300, 300);
		 *   triangle_mc.lineTo(100, 300);
		 *   triangle_mc.lineTo(200, 200);
		 *   </listing>
		 */
		public function LineStyle(thickness:Number=0, color:uint=0x000000, alpha:Number=1, pixelHinting:Boolean=false, scaleMode:String="normal", caps:String=null, joints:String=null, miterLimit:Number=3):void
		{
			this.miterLimit = miterLimit;
			this.joints = joints;
			this.caps = caps;
			this.scaleMode = scaleMode;
			this.pixelHinting = pixelHinting;
			this.alpha = alpha;
			this.color = color;
			this.thickness = thickness;
			
		}
		
	}

}