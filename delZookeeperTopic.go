package main

import (
	"fmt"
	"os"
	"io"
	"bufio"
	"time"
	"github.com/samuel/go-zookeeper/zk"
	"strconv"
)

func main() {

	f, _ := os.Open("topic")
	buf := bufio.NewReader(f)
	var path []string

	for {
		a, _, err := buf.ReadLine()
		if err == io.EOF {
			break
		} else if err != nil {

		}
		path = append(path, string(a))
	}
	var hosts = []string{"***:2181"} //server端host
	conn, _, err := zk.Connect(hosts, time.Second*1000)

	if err != nil {
		fmt.Println(err.Error())
	}
	for _, val := range path {
		topicPath := "/brokers/topics/" + val
		basePath := "/brokers/topics/" + val + "/partitions/"
		for i := 0; i < 3; i++ {
			pathNode := basePath + strconv.Itoa(i)
			_, _, _, err = conn.ExistsW(pathNode)
			if err != nil {
				fmt.Sprintf("node does not exist: %s",pathNode)
			}
			pathState := pathNode + "/state"
			_, _, _, err = conn.ExistsW(pathState)
			if err != nil {
				fmt.Sprintf("node does not exist: %s",pathState)
			}
			err = conn.Delete(pathState, -1)
			if err != nil {
				fmt.Sprintf("node does not exist: %s",pathState)
			}
			err = conn.Delete(pathNode, -1)
			if err != nil {
				fmt.Sprintf("node does not exist: %s",pathNode)
			}
		}
		partPath := "/brokers/topics/" + val + "/partitions"
		err = conn.Delete(partPath, -1)
		if err != nil {
			fmt.Sprintf("node does not exist: %s",basePath)
		}

		err = conn.Delete(topicPath, -1)
		if err != nil {
			fmt.Sprintf("node does not exist: %s",topicPath)
		}

	}

}
