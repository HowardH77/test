# Name:        HHlib.awk
# Description: AWK function library.
#              Note: Function signature use the convention function
#                    local variables are declared in the signature
#                    See awk examples in Programming Pearls by John Bentley
#
#              Example usage:
#              $ awk -f lib.awk --source '
#                     { x[cnt++] = $1; print "TRACE: x[" cnt - 1 "] = " $1; }
#                END  { print "";
#                       print "avg(x, " cnt ") = " avg(x, cnt);
#                       print "stddev(x, " cnt ") = " stddev(x, cnt);
#                     }
#                '


function avg(array_of_nums, array_size,   _sum, _indx)
{
        _sum = 0;
        for (_indx = 0; _indx < array_size; ++_indx) {
                # print "TRACE: array[" _indx "] = " array_of_nums[_indx];
                _sum += array_of_nums[_indx];
        }
        return _sum / array_size;
}


function stddev(array_of_nums, array_size,   _mean, _indx, _sum_diff)
{
        _mean = avg(array_of_nums, array_size);
        _sum_diff = 0;
        for (_indx = 0; _indx < array_size; ++_indx) {
                _sum_diff += (array_of_nums[_indx] - _mean) ^ 2;
        }
        return (_sum_diff / array_size) ^ .5;
}


function basename(filename,  _filename, _ndirs)
{
        _ndirs = split(filename, _filename, /\//)
        return _filename[_ndirs]
}
