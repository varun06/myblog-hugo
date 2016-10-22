+++
date = "2016-10-22T07:35:43-05:00"
title = "remove big file from git repo"
tags = [
  "git"
]
categories = [
  "technical",
]

+++

Sometimes you push a big binary/text(etc.) file to your git repo and these files stay in your git history. Your repo size go to roof and it takes time to clone that repo, which is a big pain. One of my git repo at work had a big binary(logstash deb file) in history and it was inflating the repo size to over 80mb. So I thought of cleaning the repo and bring down the size. I am sure there are many ways to do it but I am going to write down what I did so somebody else can also benefit.

I used a tool called **BFG Repo cleaner**. BFG cleans bad data from git repo. BFG can be downloaded [here](http://repo1.maven.org/maven2/com/madgag/bfg/1.12.13/bfg-1.12.13.jar) and provides a comprehensive list of option to clean git repo. It is an alternative to `git-filter-branch`, which I have no idea about.

To use BFG on a git repo follow these steps:

First clone a fresh copy of your repo, using the `--mirror` flag:

```
$ git clone --mirror git://github.com/big-repo.git
```

Run the BFG to clean any big file that has a size greater then 100mb:

```
$ java -jar bfg.jar --strip-blobs-bigger-than 100M big-repo.git
```

Or, if you know the name of file, you can give the name too:

```
$ java -jar bfg.jar --delete-files file_name  big-repo.git 
```

After running the command above, BFG will update your commits and all branches and tags so they are clean, but it doesn't physically delete the unwanted stuff. Examine the repo to make sure your history has been updated, and then use the standard `git gc` command to strip out the unwanted dirty data, which Git will now recognise as surplus to requirements:

```
$ cd big-repo 
$ git reflog expire --expire=now --all && git gc --prune=now --aggressive
```

Finally, once you're happy with the updated state of your repo, push it back up (note that because your clone command used the `--mirror` flag, this push will update all refs on your remote server):

```
$ git push
```

Once you push new and clean history to your repo, ditch old copies of the repo and then fresh clone/fork. Delete the old clones as they have dirty history, if you have some PR's, fetch them from master or cherry pick the commits you want. 

After all these your repo size should be significantly lower. In my case, I brought the size down from 82mb to 4.1mb.

Let me know if you have any question or suggestions.
