# Debugging guide

From chrome inspector to the source folder. Let us guide you. Forget about searching in the project source-code for some abstract code-logic, everything is now transparent! How? Because we are using BEM and flat file structures.

## Watch an explanation video

<iframe width="560" height="315" src="https://www.youtube.com/embed/LBSovCTT7rM" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## From the class name to the component

Everyone is struggling to remember the component names, especially on such a huge project! We got you covered - you can immediately pin-point the necessary component by a single look:

1. Select a target an element on the website
2. Inspect it using the debugger
3. Get back to project, make sure the `vendor/scandipwa/source` is add to your workspace
4. Focus attention on the class name:
   1. it will look like this: `<BLOCK>-<ELEMENT>_<MODIFIER>`, or this `<BLOCK>-<ELEMENT>`, or just: `<BLOCK>`
   2. Take the first part, the `<BLOCK>` part of the class
   3. Using the filename search, search for `<BLOCK>`
   4. Open the `<BLOCK>.component`, `<BLOCK>.container`, `<BLOCK>.style` - depending on your needs
   5. Now, you can extend it, modify it, or simply investigate

## Configure the remote debugging

If you have troubles inspecting the element or debugging JavaScript - checkout our [Chrome debugger](http://localhost:4000/#/scandipwa/development?id=chrome-remote-debugging) configuration tutorial.

## Something is breaking for seemingly no reason?

[Join the Slack channel](https://join.slack.com/t/scandipwa/shared_invite/enQtNzE2Mjg1Nzg3MTg5LTQwM2E2NmQ0NmQ2MzliMjVjYjQ1MTFiYWU5ODAyYTYyMGQzNWM3MDhkYzkyZGMxYTJlZWI1N2ExY2Q1MDMwMTk) and do not hesitate to share your problem there!
