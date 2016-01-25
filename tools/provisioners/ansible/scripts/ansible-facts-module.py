"""
Fundamentally, ansible modules simply accept a JSON string as input, do work,
and return a JSON string as output to stdout.  At no time should anything be
printed that is not the final JSON output, or exceptions be returned

This if this module was called site_facts can be included via a play like so:
---
- name: Gather facts
  action: site_facts
  tags:
    - always
"""
import re
import functools

def ssh_facts(module):
    """
    Collect facts for the ssh installations
    """
    #Prior to Python 3, there was not a good subprocess module
    #So ansible includes their own with the necessary options set
    rc, out, err = module.run_command(args=['ssh', '-V'])
    if rc == 0:
        ssh_version = str(err).split(',')[0]
        ssh_version = ssh_version[8:]
    else:
        ssh_version = '0.0p0'

    try:
        major_version, minor_version, patch_version = \
                re.match(r'(\d+)\.(\d+)p(\d+)', ssh_version).groups()
    except AttributeError:
        ssh_version = '0.0p0'
        major_version, minor_version, patch_version = (0, 0, 0)

    return {
        "ssh_version": ssh_version,
        "ssh_major_version": major_version,
        "ssh_minor_version": minor_version,
        "ssh_patch_version": patch_version,
    }

FACTS = {
    "ssh": ssh_facts,
}

def main():
    """
    This is the main method, to extend this module, add an entry to FACTS
    and write a function that gathers the necessary information
    """

    #Here are where the arguments to the module are examined
    #The quotes around str are important
    module = AnsibleModule(argument_spec=dict(
        name=dict(type='str', default='*'),
    ))

    name = module.params['name']
    results = []

    if name == "*":
        results = [FACTS[fact](module) for fact in FACTS]
    else:
        results = [FACTS[name](module)]

    #Unify the dictionaries returned from each command into a single dictionary
    facts = dict(functools.reduce(set.union, map(set, map(dict.items, results))))

    module.exit_json(changed=False, ansible_facts=facts)

from ansible.module_utils.basic import *
if __name__ == '__main__':
    main()
