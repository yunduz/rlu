import sys, math


# class CounterExperiment(object):

#     def __init__(self):

def avg(lst):
    return float(sum(lst))/len(lst)

def get_mean_stddev(lst):
    mean = avg(lst)
    deviations_sum = 0

    for item in lst:
        deviations_sum += (item - mean)**2

    variance = (1.0*deviations_sum)/len(lst)
    stddev = math.sqrt(variance)

    return mean, stddev

def process_log():
    file_in_n = sys.argv[1]
    file_out_n = sys.argv[2]


    num_threads = 0
    experiment_runs = {}
    with open(file_in_n, 'r') as f_in:
        for line in f_in:
            line = line.split()
            #print line
            if line: #if line was not an empty line
                #print line
                num_threads = int(line[0])
                if num_threads not in experiment_runs:
                    experiment_runs[num_threads] = [[],[],[],[]]
                experiment_runs[num_threads][0].append(float(line[-1]))
                experiment_runs[num_threads][1].append(int(line[1]))
                experiment_runs[num_threads][2].append(int(line[2]))
                experiment_runs[num_threads][3].append(int(line[3]))

                #print experiment_runs

    with open(file_out_n, 'w') as f_out:
        f_out.write("num_threads,ops/us,std_dev_ops/us,"
                    "update_rate,duration,max_writeset\n")
        thread_nums = sorted(experiment_runs.keys())

        for thread_count in thread_nums:
            #print experiment_runs[thread_count]
            ops_us = get_mean_stddev(
                                    experiment_runs[thread_count][0])
            update_rate = experiment_runs[thread_count][1][0]
            duration = experiment_runs[thread_count][2][0]
            max_writeset = experiment_runs[thread_count][3][0]
            f_out.write('%d,%.6f,%.6f,%d,%d,%d\n' % (thread_count, ops_us[0], ops_us[1], update_rate, duration, max_writeset))

# print get_mean_stddev([2,4,4,4,5,5,7,9])
# print get_mean_stddev([600, 470, 170, 430, 300])

process_log()
