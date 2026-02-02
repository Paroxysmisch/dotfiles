function grace-mount --wraps='sshfs ys562@grace:/ ~/mnt/grace' --description 'alias grace-mount sshfs ys562@grace:/ ~/mnt/grace'
  sshfs ys562@grace:/ ~/mnt/grace $argv
        
end
