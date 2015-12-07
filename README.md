# Sane Router (for React)

…because most routers suck at something. Sane Router supports:

- **location-dependent** and **location-independent** (in-memory) routing

  ```javascript
  var locationRouter = createRouter()
  var memoryRouter = createRouter({ historyDriver: 'memory' })
  ```

- **pathname base** (root)

  ```javascript
  var router = createRouter({ locationBase: '/app' })
  router.setRoutes({
    '/my/path': 'my-target',
  })
  // Routes /app/my/path as /my/path, thus to the "my-target" target.
  // Pathnames outside the /app namespace are ignored.
  ```

- **multiple instances** living side-by-side without interfering

  ```javascript
  var router1 = createRouter({ historyDriver: 'memory' })
  var router2 = createRouter({ historyDriver: 'memory' })
  ```

- **plain React elements**

  ```javascript
  router.registerTarget('homepage', <Homepage />)

  <App>
    {router.createTargetElement()}
  </App>
  ```

- route **aliasing**

  ```javascript
  router.setRoutes({
    '/projects': 'projects/index',
    '/': '/projects', // also points at projects/index
  })
  ```

- **route parameters**

  ```javascript
  router.setRoutes({
    '/projects/:id/edit': 'edit',
    '/edit/:id': '/projects/:id/edit', // alias with a parameter
  })
  router.registerTarget('edit', ({ id }) => { <EditForm id={id} /> })
  ```

- **seamless error page** registration, error page is just another target

  ```javascript
  router.registerTarget(router.StatusCodes.NOT_FOUND, <PageNotFound />)
  router.setRoutes({
    '/fake-page': router.StatusCodes.NOT_FOUND,
  })
  ```

  Note: The `router.StatusCodes.NOT_FOUND` target is used for missing routes. The target is, however, not registered by default and `router.createTargetElement()` is an empty `<div>` element.

- **React contexts** as there are no inner `render()` calls

  ```javascript
  class App extends React.Component {
    childContextTypes: { myService: React.PropTypes.object }
    getChildContext() { { myService } }
    render() { router.createTargetElement() }
  }

  class MyTargetContent extends React.Component {
    contextTypes: { myService: React.PropTypes.object }
    render() { <span>{this.context.myService.data}</span> }
  }

  myService = { data: 'Whoa' }
  router.registerTarget('/path', <MyTargetContent />)
  // <App> renders <span>Whoa</span>
  ```

## Installation

```
npm install react-sane-router
```

## Usage

1. Import the factory and create a router

  ```javascript
  import { createRouter } from 'react-sane-router'

  router = createRouter()
  ```

  The default history manupulation driver

2. Declare targets

  These are React elements or React element factories. Targets can be nested.

  ```javascript
  router.registerTarget('homepage', <Homepage />)
  router.registerTarget('projects', {
    'index': <ProjectList />,
    'detail': ({ id }) => { <Project projectId={id} /> },
    'edit': ({ id }) => { <EditProjectForm projectId={id} /> },
  })
  ```

3. Declare routes

  A route is a pathname mapping onto a target or a different pathname. Nested targets are referenced with *target paths*.

  ```javascript
  router.setRoutes({
    '/': 'homepage',
    '/projects': 'projects/index',
    '/projects/:id': 'projects/detail',
    '/projects/:id/edit': 'projects/edit',
  })
  ```

4. Insert the target element to the render tree

  This can be wherever desired in the tree, the following demonstrates insertion to the root component `App`.

  ```javascript
  var App = ({ router }) => {
    <div class="app">{router.createTargetElement()}</div>
  }

  var node = document.createElement('div')
  document.body.appendChild(node)
  ReactDOM.render(<App router={router} />, node)
  ```

## Examples

Check out the `examples/` directory.

You can build and run the examples on your machine:

```
git clone git://github.com/jankuca/react-sane-router.git
cd react-sane-router
npm install
npm run build-examples
open examples/single-router/index.html
```
