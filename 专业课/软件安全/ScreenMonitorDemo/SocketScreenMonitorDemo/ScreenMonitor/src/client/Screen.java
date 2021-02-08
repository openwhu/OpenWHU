package client;

import java.awt.Dimension;
import java.awt.Rectangle;
import java.awt.Robot;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.io.File;

import javax.imageio.ImageIO;

public class Screen {
	public static void capture() {
		int index=0;
        File f=null;
        /*
         * 一次调用截取0-100共101张截图
         * */
        Dimension d = Toolkit.getDefaultToolkit().getScreenSize();
        while(index<=GlobalVarClientRepo.MaxCaptureIndex){
            try{
                BufferedImage screenShot = (new Robot()).createScreenCapture(new Rectangle(0, 0,(int)d.getWidth(), (int)d.getHeight()));
                BufferedImage screenShot_small= new BufferedImage((int)d.getWidth()/2,(int)d.getHeight()/2 , BufferedImage.TYPE_INT_BGR);
                screenShot_small.getGraphics().drawImage(screenShot, 0, 0,(int)d.getWidth()/2,(int)d.getHeight()/2, null);
                f=new File(
                		GlobalVarClientRepo.repoFolderStr+GlobalVarClientRepo.screenShotPrefixStr
                		+String.valueOf(index)+"."+GlobalVarClientRepo.screenShotTypeStr);
                ImageIO.write(screenShot_small,GlobalVarClientRepo.screenShotTypeStr,f);
                Thread.sleep(100);
            }catch (Exception e){
                e.printStackTrace();
            }
            index++;
        }
        System.out.println("[Log]: capture finish");
	}
}
