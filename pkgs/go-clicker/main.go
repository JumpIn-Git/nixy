package main

import (
	"fmt"
	"os"
	"os/exec"
	"os/signal"
	"strconv"
	"syscall"
	"time"
)

func Must(err error) {
	if err != nil {
		panic(err)
	}
}

func MustReturn[T any](x T, err error) T {
	Must(err)
	return x
}

func main() {
	ydotoolPath := MustReturn(exec.LookPath("ydotool"))
	notifySendPath := MustReturn(exec.LookPath("notify-send"))
	pid := os.Getpid()
	pidFile := "/tmp/autoclick_daemon.pid"
	Must(os.WriteFile(pidFile, []byte(strconv.Itoa(pid)), 0644))
	defer os.Remove(pidFile)

	enabled := false
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGUSR1)

	go func() {
		for range sigChan {
			enabled = !enabled
			if enabled {
				fmt.Println("Enabled")
				Must(exec.Command(notifySendPath, "-t", "1500", "Auto-Clicker", "Enabled").Run())
			} else {
				fmt.Println("Disabled")
				Must(exec.Command(notifySendPath, "-t", "1500", "Auto-Clicker", "Disabled").Run())
			}
		}
	}()

	fmt.Println("Running")
	for {
		if enabled {
			Must(exec.Command(ydotoolPath, "click", "0xC0").Run())
			time.Sleep(50 * time.Millisecond)
		} else {
			time.Sleep(100 * time.Millisecond)
		}
	}
}
