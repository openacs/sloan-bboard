ad_library {

    bboard init - sets up scheduled procs

    @cvs-id $Id$
    @author Anukul Kapoor <akk@arsdigita.com>
    @date 2001-02-13

}

ad_schedule_proc -thread t 86400 bboard_garbage_collect