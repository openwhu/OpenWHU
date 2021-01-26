package server;

public class GlobalVarServerRepo {
	public static String clientIP="127.0.0.1";
	public static int port=8000;
	public static String repoFolderStr="ReceiveCache";
	
	public static volatile int playerRepoNum=0;
	public static volatile int storeRepoNum=0;
	
	
	public static String screenShotPrefixStr="/screenShot";
	public static String screenShotTypeStr="jpg";
	public static int MaxCaptureIndex=100;
	
}
