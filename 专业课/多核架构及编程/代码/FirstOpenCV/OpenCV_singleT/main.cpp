#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <iostream>
#include <omp.h>
#include <time.h>

using namespace cv;
using namespace std;

int main()
{
	Mat image[4];
	string filename, windowname;
	int i;
	time_t start, finish;
	start = clock();
	for (i = 0; i < 4; i++)
	{
		filename = "../cat" + to_string(i + 1) + ".jpg";
		windowname = "Cat" + to_string(i + 1);
		namedWindow(windowname, WINDOW_AUTOSIZE);
		image[i] = imread(filename, 1);
		imshow(windowname, image[i]);
	}
	finish = clock();

    waitKey(0); // Wait for a keystroke in the window
	destroyAllWindows();
	cout << "单线程打开图片共用时：" << ((double)(finish - start) / CLOCKS_PER_SEC) << "秒" << endl;
    return 0;
}