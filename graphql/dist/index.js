import { ApolloServer } from "@apollo/server";
import { startStandaloneServer } from "@apollo/server/standalone";
import dateScalar from "./scalars/date_scalar.js";
import tasks from "./tasks.js";
import workflows from "./workflows.js";
// A schema is a collection of type definitions (hence "typeDefs")
// that together define the "shape" of queries that are executed against
// your data.
const typeDefs = `#graphql
  # Comments in GraphQL strings (such as this one) start with the hash (#) symbol.
  scalar Date

  # This "Book" type defines the queryable fields for every book in our data source.
  type Book {
    title: String
    author: String
  }

  type Workflow{
    id: ID!
    projectId: String!
    name: String!
  }

  type Task {
    id: ID!
    workflowId: String!
    name: String!
    index: Int!
    description: String
    createdAt: Date!
  }

  type Mutation{
    addTask(name: String, description: String): Task
    addWorkflow(id: ID!, projectId: String!, name: String!) : Workflow
  }

  # The "Query" type is special: it lists all of the available queries that
  # clients can execute, along with the return type for each. In this
  # case, the "books" query returns an array of zero or more Books (defined above).
  type Query {
    tasks: [Task]
    workflows: [Workflow]
    workflow(projectId: ID!): [Workflow]
    tasksByWorkflowId(workflowId: ID!): [Task!]!
  }
`;
const resolvers = {
    Date: dateScalar,
    Query: {
        workflows: () => workflows,
        workflow(parent, args, contextValue, info) {
            return workflows.filter((workflow) => workflow.projectId === args.projectId);
        },
        tasks: () => tasks,
        tasksByWorkflowId(parent, args, contextValue, info) {
            const filteredTasks = tasks.filter((task) => task.workflowId === args.workflowId);
            filteredTasks.sort((a, b) => a.index - b.index);
            return filteredTasks;
        },
    },
    Mutation: {
        addTask(parent, args, contextValue, info) {
            let task = { ...args };
            tasks.push(task);
            return task;
        },
        addWorkflow(_, args, contextValue) {
            let workflow = { ...args };
            workflows.push(workflow);
            return workflow;
        },
    },
};
const server = new ApolloServer({ typeDefs, resolvers });
const { url } = await startStandaloneServer(server, { listen: { port: 4000 } });
console.log(`🚀  Server ready at: ${url}`);
