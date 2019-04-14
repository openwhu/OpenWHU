using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DSAGL
{
    public class Sort<T> where T : IComparable<T>
    {
        public void InsertSort(IList<T> datas, bool sortDown = false)
        {
            /*
             * 1、从第一个元素开始，该元素可以认为有序
             * 2、取出下一个元素，在有序的元素序列中从后向前扫描，直至已排序元素小于/等于新元素
             * 3、将新元素插入到该位置
             * 4、重复步骤2~3
             */
            int index;
            T currentData;
            for(int i = 1; i < datas.Count; i++)
            {
                index = i - 1;
                currentData = datas[i];
                if (sortDown)
                {
                    while ((index >= 0) && (datas[index].CompareTo(currentData) < 0))
                    {
                        datas[index + 1] = datas[index];
                        index--;
                    }
                }
                else
                {
                    while ((index >= 0) && (datas[index].CompareTo(currentData) > 0))
                    {
                        datas[index + 1] = datas[index];
                        index--;
                    }
                }
                datas[index + 1] = currentData;
            }
        }

        public void BubbleSort(IList<T> datas, bool sortDown = false)
        {
            /*
             * 1、比较相邻的元素。如果第一个比第二个大，就交换它们两个
             * 2、对每一对相邻元素作同样的工作，从开始第一对到结尾的最后一对
             * 3、针对所有的元素重复以上的步骤，除了最后一个
             * 重复步骤1~3，直到排序完成
             */
            for (int i = 0; i < datas.Count; i++)
            {
                for(int j = 0; j < (datas.Count - i - 1); j++)
                {
                    if (sortDown)
                    {
                        if (datas[j].CompareTo(datas[j + 1]) < 0)
                        {
                            T t = datas[j];
                            datas[j] = datas[j + 1];
                            datas[j + 1] = t;
                        }
                    }
                    else
                    {
                        if (datas[j].CompareTo(datas[j + 1]) > 0)
                        {
                            T t = datas[j];
                            datas[j] = datas[j + 1];
                            datas[j + 1] = t;
                        }
                    }
                }
            }
        }

        public void SelectSort(IList<T> datas, bool sortDown = false)
        {
            /*
             * 首先在未排序序列中找到最小（大）元素，存放到排序序列的起始位置;
             * 然后，再从剩余未排序元素中继续寻找最小（大）元素，然后放到已排序序列的末尾;
             * 以此类推，直到所有元素均排序完毕
             */
            int min = 0;
            for (int i = 0; i < datas.Count; i++)
            {
                min = i;
                for (int j = i; j < datas.Count; j++)
                {
                    if (sortDown)
                    {
                        if (datas[min].CompareTo(datas[j]) < 0)
                        {
                            min = j;
                        }
                    }
                    else
                    {
                        if (datas[min].CompareTo(datas[j]) > 0)
                        {
                            min = j;
                        }
                    }
                }
                T temp = datas[min];
                datas[min] = datas[i];
                datas[i] = temp;
            }
        }

        public void QuickSort(IList<T> datas, int left, int right, bool sortDown = false)
        {
            /*
             * 1、从数列中挑出一个元素，称为 “基准”（pivot）
             * 2、重新排序数列，所有比基准值小的放在基准前面，所有比基准值大的放在基准后面
             * （相同的数可以到任一边）。在这个分区退出之后，该基准就处于数列的中间位置。
             *  这个称为分区（partition）操作
             * 3、递归地（recursive）把小于基准值元素的子数列和大于基准值元素的子数列排序
             */
            /*int partitionIndex, len;
            len = datas.Count - 1;
            left = left < 0 ? 0 : left;
            right = right > left ? (right > len ? len : right) : len;

            partitionIndex = partition(datas, left, right, sortDown);
            QuickSort(datas, left, partitionIndex - 1);
            QuickSort(datas, partitionIndex + 1, right);*/
            if(left < right)
            {
                int partitionIndex = partition(datas, left, right, sortDown);
                QuickSort(datas, left, partitionIndex - 1, sortDown);
                QuickSort(datas, partitionIndex + 1, right, sortDown);
            }
        }

        public void MergeSort(IList<T> datas, int left, int right, bool sortDown = false)
        {
            if (left == right)//当待排序的序列长度为1时，递归开始回溯，进行merge操作
                return;
            int mid = (left + right) / 2;
            MergeSort(datas, left, mid, sortDown);
            MergeSort(datas, mid + 1, right, sortDown);
            merge(datas, left, mid, right, sortDown);
        }

        public void ShellSort(IList<T> datas, int n, bool sortDown = false)
        {
            int h = 0;
            while (h <= n)// 生成初始增量
            {
                h = 3 * h + 1;
            }
            while (h >= 1)
            {
                for (int i = h; i < n; i++)
                {
                    int j = i - h;
                    T get = datas[i];
                    while (j >= 0 && (sortDown ? datas[j].CompareTo(get) < 0 
                                               : datas[j].CompareTo(get) > 0))
                    {
                        datas[j + h] = datas[j];
                        j = j - h;
                    }
                    datas[j + h] = get;
                }
                h = (h - 1) / 3;// 递减增量
            }
        }

        public void HeapSort(IList<T> datas, bool sortDown = false)
        {
            T t;
            int i, n = datas.Count();
            for(i = n - 1; i > 1; i--)
            {
                heapAdjust(datas, i, n, sortDown);
            }
            for(i = n - 1; i > 1; i--)
            {
                t = datas[0];
                datas[0] = datas[i];
                datas[i] = t;
                heapAdjust(datas, 0, i, sortDown);
            }
        }

        private static int partition(IList<T> datas, int left, int right, bool sortDown = false)
        {
            T t, pivot = datas[left];
            int nLeft = left + 1;
            int nRight = right;
            while(nLeft <= nRight)
            {
                if (sortDown)
                {
                    while (nLeft <= nRight && (datas[nLeft].CompareTo(pivot) >= 0))
                    {
                        nLeft++;
                    }
                    while (nLeft <= nRight && (datas[nRight].CompareTo(pivot) < 0))
                    {
                        nRight--;
                    }
                }
                else
                {
                    while (nLeft <= nRight && (datas[nLeft].CompareTo(pivot) <= 0))
                    {
                        nLeft++;
                    }
                    while (nLeft <= nRight && (datas[nRight].CompareTo(pivot) > 0))
                    {
                        nRight--;
                    }
                }
                if(nLeft < nRight)
                {
                    t = datas[nLeft];
                    datas[nLeft] = datas[nRight];
                    datas[nRight] = t;
                    nLeft++;
                    nRight--;
                }
            }
            t = datas[left];
            datas[left] = datas[nRight];
            datas[nRight] = t;
            return nRight;
            /*int pivot = left, index = pivot + 1;
            T temp;
            for (int i = index; i <= right; i++)
            {
                if (sortDown)
                {
                    if (datas[i].CompareTo(datas[pivot]) > 0)
                    {
                        temp = datas[i];
                        datas[i] = datas[index];
                        datas[index] = temp;
                        index++;
                    }
                }
                else
                {
                    if (datas[i].CompareTo(datas[pivot]) < 0)
                    {
                        temp = datas[i];
                        datas[i] = datas[index];
                        datas[index] = temp;
                        index++;
                    }
                }
            }
            temp = datas[pivot];
            datas[pivot] = datas[index - 1];
            datas[index - 1] = temp;
            return index - 1;*/
        }

        //合并两个已排好序的数组datas[left...mid]和datas[mid+1...right]
        private static void merge(IList<T> datas, int left, int mid, int right, bool sortDown)
        {
            int len = right - left + 1;
            T[] temp = new T[len];//辅助空间O(n)
            int index = 0;
            int i = left;//前一数组的起始元素
            int j = mid + 1;//后一数组的起始元素
            while (i <= mid && j <= right)
            {
                if (sortDown)
                {
                    //等于号可以保证算法稳定性
                    temp[index++] = (datas[i].CompareTo(datas[j]) >= 0) ? datas[i++] : datas[j++];
                }
                else
                {
                    temp[index++] = (datas[i].CompareTo(datas[j]) <= 0) ? datas[i++] : datas[j++];
                }
            }
            while (i <= mid)
            {
                temp[index++] = datas[i++];
            }
            while (j <= right)
            {
                temp[index++] = datas[j++];
            }
            for (int k = 0; k < len; k++)
            {
                datas[left++] = temp[k];
            }
        }

        private static void heapAdjust(IList<T> datas, int s, int m, bool sortDown)
        {
            int i = s;
            int j = 2 * i + 1;
            T t = datas[i];
            while(j < m - 1)
            {
                if(datas[j].CompareTo(datas[j + 1]) < 0)
                {
                    j++;
                }
                if(datas[j].CompareTo(t) > 0)
                {
                    datas[i] = datas[j];
                    i = j;
                    j = 2 * i + 1;
                }
                else
                {
                    break;
                }
            }
            datas[i] = t;
        }
    }
}
