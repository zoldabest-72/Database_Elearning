function checkPermit(role) {
    return (req, res, next) => {
        if (typeof req.user !== 'undefined') {
            if (req.user.role == role) next();
            else {
                if (req.user.role == 'Student') {
                    res.redirect('/student');
                } else if (req.user.role == 'Lecturer') {
                    res.redirect('/lecturer');
                } else if (req.user.role == 'AAOStaff') {
                    res.redirect('/aao');
                } else if (req.user.role == 'FacultyOfficer') {
                    res.redirect('/faculty');
                }

            }
        } else {
            res.redirect('/user/login');
        }
    }
} // a thoi dc roi tui hieu roi, de tui tu fix, chac nay quen bam apply :") fix thử đi đucợ k okđucợ thì thôi k t coint"
module.exports = checkPermit;