import jenkins.model.Jenkins
import hudson.model.Computer

Jenkins.instance.nodes.each { node ->
    def computer = node.toComputer() 
    if (computer != null && computer.isOffline()) {
        Jenkins.instance.removeNode(node)
    }
}