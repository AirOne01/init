import prompts from 'prompts';
import ora from 'ora';

import { textSync } from 'figlet';
import { spawnSync } from 'child_process';

(async () => {
  console.log(textSync('env setup wizard'))

  let skipEverything = (await prompts({
    type: 'confirm',
    name: 'value',
    message: '[FAST MODE] Skip every check and let the script decide for me ?',
    initial: false
  })).value

  switch ((await prompts({
    type: 'select',
    name: 'value',
    message: 'Pick your package manager',
    choices: [
      { title: 'apt-get (Debian, Ubuntu, etc...)', value: 'apt' },
      { title: 'pacman (Arch, Manjaro, etc...)', value: 'pacman' }
    ],
    initial: 0
  })).value) {
    case 'apt':
      let packets = 'make build-essential git htop curl wget docker.io nano vim unzip'.split(' ');
      if (!skipEverything && !(await prompts({
        type: 'confirm',
        name: 'value',
        message: 'Install all recommended packages ?',
        initial: true
      })).value) {
        packets = (await prompts({
          type: 'multiselect',
          name: 'value',
          message: 'Which packages to install ?',
          choices: packets.map(e => { return { title: e }})
        })).value;
      }
      spawnSync('sudo');
      const spin = ora('Installing apt packages...').start();
      const apt = spawnSync('apt', [ 'install', ...packets ]);
      spin.stop();
      break;
  }
})()
