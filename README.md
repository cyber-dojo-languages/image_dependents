
[![CircleCI](https://circleci.com/gh/cyber-dojo-languages/image_dependents.svg?style=svg)](https://circleci.com/gh/cyber-dojo-languages/image_dependents)

- finds which [cyber-dojo-languages](https://github.com/cyber-dojo-languages) repos have a Dockerfile which is dependent on another given [cyber-dojo-languages](https://github.com/cyber-dojo-languages) repo.
- for example, [python-assert](https://github.com/cyber-dojo-languages/python-assert), [python-behave](https://github.com/cyber-dojo-languages/python-behave), [python-pytest](https://github.com/cyber-dojo-languages/python-pytest), and [python-unitest](https://github.com/cyber-dojo-languages/python-unittest) are all dependent on [python](https://github.com/cyber-dojo-languages/python) since they all have a Dockerfile which is built FROM it.
- used in the main [build_test_push_notify.sh](https://github.com/cyber-dojo-languages/image_builder/blob/master/build_test_push_notify.sh) script of all [cyber-dojo-languages](https://github.com/cyber-dojo-languages) repos .circleci/config.yml files

```bash
$ git clone https://github.com/cyber-dojo-languages/python.git
$ cd python
$ docker run --rm --volume "${PWD}:/data:ro" cyberdojofoundation/image_dependents
python-assert python-behave python-pytest python-unittest
```

- - - -

![cyber-dojo.org home page](https://github.com/cyber-dojo/cyber-dojo/blob/master/shared/home_page_snapshot.png)
