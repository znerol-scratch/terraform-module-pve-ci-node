polkit.addRule(function(action, subject) {
  if (action.id == "org.libvirt.unix.manage" &&
      subject.local && subject.active && subject.user == "{{USER}}") {
    return polkit.Result.YES;
  }
});
