package effects
{
    import flash.geom.Matrix;
    //import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.display.Shape;
    import flash.events.Event;
    import dupin.display.bitmapData;
    import flash.filters.BitmapFilter;
    import flash.filters.DisplacementMapFilterMode;
    import flash.display.BitmapDataChannel;
    import flash.geom.Point;
    import flash.filters.DisplacementMapFilter;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import base.Effect;

    [SWF(width='1024', height='768', backgroundColor='#FFFFFF', frameRate='60')]
    public class Effect27 extends Effect
    {   
        private var PIXELATE:int = 600;
        private const PIXEL_SIZE:Number = 500;
        private var DISPLACE:Number = 10;

        private const pseudoRandom:Array = [0.5199086396752618, 0.30736234641224525, 0.7621809688507171, 0.22931704024263555, 0.8443104257449167, 0.9495348033593234, 0.8335931369864429, 0.10187622146889486, 0.7427912321672244, 0.7896974803310505, 0.4960557795640256, 0.5185744733514968, 0.7986652529157834, 0.9813295587896443, 0.9644369216948246, 0.32041954779087967, 0.40950091544688905, 0.1683986463505276, 0.31851663251877327, 0.6355901307699298, 0.9644745327921961, 0.8050602558266289, 0.06305383336031323, 0.009596499279783344, 0.38723535172560664, 0.16402281195816326, 0.3694850165430452, 0.19573880400135635, 0.3371698739436294, 0.12212451061983398, 0.5927968918003113, 0.38312403110656423, 0.8447538455391376, 0.09502167801087702, 0.15560415845476272, 0.425362367867115, 0.8138894666323951, 0.23646426449128544, 0.7421350038947998, 0.556785898563092, 0.4327602389506069, 0.11049734642257791, 0.013664617391170641, 0.15553400966117947, 0.9291971745423215, 0.523570447071224, 0.37788673486827684, 0.5443327571177635, 0.9593073955634335, 0.3475133090504504, 0.2437563831737617, 0.17186965825637146, 0.6445491483686066, 0.1361174090639754, 0.580844990157493, 0.17700642349062712, 0.8275785856701019, 0.9165178371936109, 0.21153948349687746, 0.3809857206407359, 0.9443941418753731, 0.15139329585598382, 0.1320232607030476, 0.18779576828582611, 0.45367908807127655, 0.12455626608243464, 0.7147147219500595, 0.7763268092852452, 0.13004159838795215, 0.8826899066717733, 0.12585518562102893, 0.3218956935632563, 0.1270440550107551, 0.6923387503818698, 0.598749243760628, 0.09515824092768932, 0.25432978078177315, 0.5454076207022773, 0.5010120518122585, 0.07647173672473717, 0.9763901422284941, 0.5765375356946082, 0.44495407067901027, 0.14251177798793546, 0.5355630097315497, 0.14425722837808497, 0.42951745094514326, 0.8677329293985157, 0.4895831434490612, 0.9894969830341357, 0.6145733977281379, 0.6008513181143648, 0.13683542704771856, 0.754450339672294, 0.7643303161739348, 0.28620935562222927, 0.6285179925432277, 0.42346079379823387, 0.8626260872019993, 0.9071928749443414, 0.7120978803186601];
        
        override protected function getProcessedImage(amount:Number):DisplayObject
        {
            var SIZE:Number = 200;

            amount+=0.1
            PIXELATE *= 0.15;
            DISPLACE *= amount;
            SIZE *= 0.5 + amount;

            //Create a image in the size we need
            var resizedImage:Bitmap = getInProportion(image, BOOK_WIDTH/PIXELATE, BOOK_HEIGHT/PIXELATE);
            var cpImage:Bitmap = getInProportion(image, BOOK_WIDTH, BOOK_HEIGHT);
            
            var result:Sprite = new Sprite();
            for (var x:int = 0; x < resizedImage.width; x++)
            {
                for (var y:int = 0; y < resizedImage.height; y++)
                {
                    var m:Matrix = new Matrix();
                    m.translate(x*(x%2 == 0 ? 1 : -1) * DISPLACE, y*(y%2 == 0 ? 1 : -1) * DISPLACE);
                    
                    var destX:Number = x * PIXELATE + pseudoRandom[y%pseudoRandom.length]*200;
                    var destY:Number = y * PIXELATE + pseudoRandom[x%pseudoRandom.length]*200;

                    var pixelColor:uint = resizedImage.bitmapData.getPixel(x, y);
                    var pixelSize:Number = luma(pixelColor)/255;
                    result.graphics.beginBitmapFill(cpImage.bitmapData, m);
                    result.graphics.moveTo(destX, destY);
                    result.graphics.lineTo(destX + pseudoRandom[int(x/2)]*SIZE, destY + pseudoRandom[int(y/2)]*SIZE);
                    result.graphics.lineTo(destX, destY + pseudoRandom[int(y/2)]*SIZE);
                    result.graphics.endFill();
                }
            }


            
            return result;
        }
    }
} 