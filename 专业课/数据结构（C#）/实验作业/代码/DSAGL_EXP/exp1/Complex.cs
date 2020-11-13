using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace exp1
{
    class Complex
    {
        private double image;
        private double real;

        public Complex(double real, double image)
        {
            this.real = real;
            this.image = image;
        }

        public Complex(Complex com)
        {
            real = com.Real;
            image = com.Image;
        }

        public Complex()
        {
            real = 0.0;
            image = 0.0;
        }

        public double Real
        {
            get
            {
                return real;
            }
            set
            {
                real = value;
            }
        }

        public double Image
        {
            get
            {
                return image;
            }
            set
            {
                image = value;
            }
        }

        public override string ToString()
        {
            StringBuilder s = new StringBuilder(real.ToString("F3"));
            if(real != 0)
            {
                if (image > 0)
                {
                    s.Append(" + " + image.ToString("F3") + 'i');
                }
                else
                {
                    double absimage = -1 * image;
                    s.Append(" - " + absimage.ToString("F3") + 'i');
                }
            }
            else
            {
                if (image > 0)
                {
                    s.Append(" + " + image.ToString("F3") + 'i');
                }
                else
                {
                    double absimage = -1 * image;
                    s.Append(" - " + absimage.ToString("F3") + 'i');
                }
            }
            return s.ToString();
        }

        public double Abs()
        {
            return (Math.Sqrt(real * real + image * image));
        }

        public bool Equal(Complex c)
        {
            return (this.real == c.real) && (this.image == c.image);
        }

        public static Complex operator + (Complex c1, Complex c2)
        {
            return new Complex(c1.real + c2.real, c1.image + c2.image);
        }

        public static Complex operator - (Complex c1, Complex c2)
        {
            return new Complex(c1.real - c2.real, c1.image - c2.image);
        }

        public static Complex operator * (Complex c1, Complex c2)
        {
            return new Complex(c2.real * c1.real - c2.image * c1.image, 
                c2.real * c1.image + c2.image * c1.real);
        }

        public static Complex operator / (Complex c1, Complex c2)
        {
            Complex result = new Complex();
            double denominator = c2.image * c2.image + c2.real * c2.real;
            result.real = (c1.real * c2.real + c1.image * c2.image) / denominator;
            result.image = (c1.image * c2.real - c1.real * c2.image) / denominator;
            return result;
        }
    }
}
