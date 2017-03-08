+++
date = "2015-10-04T06:30:28-06:00"
draft = false
title = "killing process with child and grandchild processes  in Go"
+++

Go provides [exec](https://golang.org/pkg/os/exec/) package in standard library to run external commands. Sometimes we need to run an external command from Go code and then kill the process created by command after certain time if it does not finish in a given time period.

We can start a process...
<pre>
	cmd := exec.Command(execPath, args...)
</pre>
and then process can be killed after certain given time....
<pre>
	case <-time.After(2 * time.Second):
		if err := cmd.Process.Kill(); err != nil {
			return 0, fmt.Errorf("Failed to kill process: %v", err)
		}
</pre>

But there is a problem with this code, what if the process start other [child processes](https://en.wikipedia.org/wiki/Child_process) and then those processes start new processes(grandchild processes). Once you kill the parent process those child processes become orphan and get a `PPID=1`. In my particular scenario I had 4-5 orphaned processes from killed parent process and then these orphaned processes were creating an issue with subsequent run of the program. 

I started looking around and found this well written article on this topic [killing a child process and all of its children in Go](https://medium.com/@felixge/killing-a-child-process-and-all-of-its-children-in-go-54079af94773).This article helped me understand how to setup a process group and kill the process.

But The solution suggested in that article was not working in my case. Then I asked this question on [Go forum](https://forum.golangbridge.org/t/killing-child-process-on-timeout-in-go-code/995) and gophers helped me to find the solution.

Now I create a process group when I create the command, then I kill the whole group on timeout and it kills the process as well as the children of the process.

<pre>
	cmd := exec.Command(execPath, args...)
	//create a new process group
	cmd.SysProcAttr = &syscall.SysProcAttr{Setpgid: true}
</pre>

<pre>
	case <-time.After(timeout):
		pgid, err := syscall.Getpgid(cmd.Process.Pid)
		if err == nil {
			if err := syscall.Kill(-pgid, syscall.SIGKILL); err != nil {
				...
			}
		}
</pre>
We get the process group id `syscall.Getpgid` and then kill the process by passing -pgid to `syscall.Kill`. We use -pgid because we want to target the group id and not the particular process id.
