
Delayed::Worker.destroy_failed_jobs = false
#Delayed::Worker.sleep_delay = 60
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.read_ahead = 5
Delayed::Worker.delay_jobs = !Rails.env.test?

#refer to http://stackoverflow.com/questions/2580871/start-or-ensure-that-delayed-job-runs-when-an-application-server-restarts
DELAYED_JOB_PID_PATH = "#{Rails.root}/tmp/pids/delayed_job.pid"

def start_delayed_job
  Thread.new do 
    `ruby script/delayed_job start`
  end
end

def daemon_is_running?
  pid = File.read(DELAYED_JOB_PID_PATH).strip
  Process.kill(0, pid.to_i)
  true
rescue Errno::ENOENT, Errno::ESRCH   # file or process not found
  false
end

#start_delayed_job unless daemon_is_running?
#Keep in mind that this code won't work if you start more than one worker. 
#And check out the "-m" argument of script/delayed_job which spawns a monitor process along with the daemon(s).
