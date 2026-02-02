function grace-umount --wraps='umount ~/mnt/grace' --description 'alias grace-umount umount ~/mnt/grace'
  umount ~/mnt/grace $argv
        
end
